import 'dart:io';

import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/forum_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForumEvent extends Equatable {
  const ForumEvent();

  @override
  List<Object?> get props => [];
}

class ForumState extends Equatable {
  const ForumState();

  @override
  List<Object?> get props => [];
}

class ReportForum extends ForumEvent {
  final String report;
  final String reportType;
  final Map<String, String> details;

  const ReportForum({
    required this.report,
    required this.details,
    required this.reportType,
  });

  @override
  List<Object?> get props => [report, reportType, details];
}

class LoadForum extends ForumEvent {
  final String? category;
  final bool hardRefresh;
  final bool loadMore;

  LoadForum({this.category, this.hardRefresh = false, this.loadMore = false});

  @override
  List<Object?> get props => [category, hardRefresh, loadMore];
}

class AddImages extends ForumEvent {
  final String forumId;
  final List<File> images;

  AddImages(this.forumId, this.images);
}

class AddForum extends ForumEvent {
  final Forum forum;
  final List<Photo> images;
  AddForum(this.forum, this.images);

  @override
  List<Object> get props => [forum, images];
}

class DeleteForum extends ForumEvent {
  final String? forumId;
  DeleteForum(this.forumId);

  @override
  List<Object?> get props => [forumId];
}

class UpdateForum extends ForumEvent {
  final Forum forum;
  final List<Photo> images;
  UpdateForum(this.forum, this.images);

  @override
  List<Object> get props => [forum, images];
}

class ForumInitial extends ForumState {}

class ForumLoadInProgress extends ForumState {}

class ForumLoadSuccess extends ForumState {
  final String? msg;
  final bool hasReachedEnd;
  final List<Forum> forums;
  final List<String>? categories;
  final List<String>? uploadedImgUrls;

  ForumLoadSuccess({
    this.msg,
    this.categories,
    this.uploadedImgUrls,
    required this.forums,
    this.hasReachedEnd = false,
  });

  @override
  List<Object?> get props =>
      [msg, forums, categories, uploadedImgUrls, hasReachedEnd];

  ForumLoadSuccess copyWith({
    String? msg,
    List<Forum>? forums,
    bool? hasReachedEnd,
    List<String>? categories,
    List<String>? uploadedImgUrls,
  }) {
    return ForumLoadSuccess(
      msg: msg ?? this.msg,
      forums: forums ?? this.forums,
      categories: categories ?? this.categories,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      uploadedImgUrls: uploadedImgUrls ?? this.uploadedImgUrls,
    );
  }
}

class ForumLoadFailure extends ForumState {
  final String error;
  ForumLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ForumBloc extends Bloc<ForumEvent, ForumState> {
  final ForumRepo repo;
  ForumBloc(this.repo) : super(ForumInitial());

  @override
  Stream<ForumState> mapEventToState(ForumEvent event) async* {
    switch (event.runtimeType) {
      case LoadForum:
        yield* _mapLoadForumEventToState(event as LoadForum);
        break;
      case AddImages:
        yield* _mapAddImagesEventToState(event as AddImages);
        break;
      case UpdateForum:
        yield* _mapUpdateForumEventToState(event as UpdateForum);
        break;
      case AddForum:
        yield* _mapAddForumEventToState(event as AddForum);
        break;
      case DeleteForum:
        yield* _mapDeleteForumEventToState(event as DeleteForum);
        break;
      case ReportForum:
        yield* _mapReportForumEventToState(event as ReportForum);
        break;
      default:
    }
  }

  Stream<ForumState> _mapReportForumEventToState(ReportForum event) async* {
    if (state is ForumLoadSuccess) {
      final curState = state as ForumLoadSuccess;
      yield ForumLoadInProgress();

      await repo.reportPost(
        report: event.report,
        details: event.details,
        reportType: event.reportType,
      );
      yield curState.copyWith(msg: 'Thank you for the report!');
    }
  }

  Stream<ForumState> _mapAddImagesEventToState(AddImages event) async* {
    if (state is ForumLoadSuccess) {
      final curState = state as ForumLoadSuccess;
      yield ForumLoadInProgress();

      final imgUrls = <String>[];
      for (final f in event.images) {
        final url = await repo.uploadImage(f);
        imgUrls.add(url);
      }
      yield curState.copyWith(uploadedImgUrls: imgUrls);
    }
  }

  Stream<ForumState> _mapLoadForumEventToState(LoadForum event) async* {
    // default categories; [TODO]: Add dynamic categories
    final categories = ['Category1', 'Category2', 'Category3'];

    // ------------------------------------------------------------------------
    // RETURN EARLY
    // IF hardRefresh == false AND loadMore == false AND FORUM IS ALREADY LOADED
    // ------------------------------------------------------------------------
    if (state is ForumLoadSuccess && !event.hardRefresh && !event.loadMore) {
      return;
    }

    // ------------------------------------------------------------------------
    // LOAD MORE ITEMS
    // IF FORUM IS ALREADY LOADED AND loadMore == true
    // ------------------------------------------------------------------------
    if (state is ForumLoadSuccess && event.loadMore) {
      final curState = state as ForumLoadSuccess;

      // ----------------------------------------------------------------------
      // RETURN EARLY
      // IF ALL THE FORUMS ARE LOADED i.e. hasReachedEnd == true
      // ----------------------------------------------------------------------

      if (curState.hasReachedEnd) {
        return;
      }

      yield ForumLoadInProgress();

      final forums = await repo.getForums(
          category: event.category,
          createdAt: curState.forums.last.createdAt!.millisecondsSinceEpoch);

      final nForums = List<Forum>.from([...curState.forums, ...forums]);

      yield curState.copyWith(
        forums: nForums,
        hasReachedEnd: forums.isEmpty,
      );
      return;
    }

    yield ForumLoadInProgress();
    final forums = await repo.getForums(category: event.category);
    yield ForumLoadSuccess(
      forums: forums,
      categories: categories,
      hasReachedEnd: forums.isEmpty,
    );
  }

  Stream<ForumState> _mapAddForumEventToState(AddForum event) async* {
    if (state is ForumLoadSuccess) {
      final curState = (state as ForumLoadSuccess);
      yield ForumLoadInProgress();

      // Add images
      final imgUrls = <String>[];
      for (final f in event.images) {
        final url = await repo.uploadImage(f.file!);
        imgUrls.add(url);
      }
      final user = await repo.getUser();

      final nForum = event.forum.copyWith(
        imageUrls: imgUrls,
        addedById: user?.id,
        addedByType: user?.type,
        addedByAvatar: user?.avatar,
        addedByName: user?.fullname,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      final forum = await repo.addForum(nForum);

      final nForums = List<Forum>.from([forum, ...curState.forums]);

      yield curState.copyWith(forums: nForums);
    }
  }

  Stream<ForumState> _mapUpdateForumEventToState(UpdateForum event) async* {
    if (state is ForumLoadSuccess) {
      final curState = state as ForumLoadSuccess;
      yield ForumLoadInProgress();

      // Add images
      final imgUrls = <String?>[];
      for (final f in event.images) {
        if (f.source == PhotoSource.File) {
          final url = await repo.uploadImage(f.file!);
          imgUrls.add(url);
        } else {
          imgUrls.add(f.url);
        }
      }

      final nForum = event.forum.copyWith(
        imageUrls: imgUrls,
        updatedAt: DateTime.now().toUtc(),
      );

      await repo.updateForum(nForum);

      yield curState.copyWith(
          forums: curState.forums
              .map((f) => f.id == event.forum.id ? nForum : f)
              .toList());
    }
  }

  Stream<ForumState> _mapDeleteForumEventToState(DeleteForum event) async* {
    if (state is ForumLoadSuccess) {
      final curState = state as ForumLoadSuccess;
      yield ForumLoadInProgress();

      await repo.delQuestion(event.forumId);

      yield curState.copyWith(
          forums: curState.forums.where((f) => f.id != event.forumId).toList());
    }
  }
}
