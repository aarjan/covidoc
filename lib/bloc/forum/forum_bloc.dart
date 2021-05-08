import 'dart:io';

import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/forum_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForumEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ForumState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadForum extends ForumEvent {}

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
  final String forumId;
  DeleteForum(this.forumId);

  @override
  List<Object> get props => [forumId];
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
  final List<Forum> forums;
  final List<String> categories;
  final List<String> uploadedImgUrls;

  ForumLoadSuccess({this.forums, this.categories, this.uploadedImgUrls});

  @override
  List<Object> get props => [forums, categories, uploadedImgUrls];

  ForumLoadSuccess copyWith({
    List<Forum> forums,
    List<String> categories,
    List<String> uploadedImgUrls,
  }) {
    return ForumLoadSuccess(
      forums: forums ?? this.forums,
      categories: categories ?? this.categories,
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
        yield* _mapLoadForumEventToState(event);
        break;
      case AddImages:
        yield* _mapAddImagesEventToState(event);
        break;
      case UpdateForum:
        yield* _mapUpdateForumEventToState(event);
        break;
      case AddForum:
        yield* _mapAddForumEventToState(event);
        break;
      case DeleteForum:
        yield* _mapDeleteForumEventToState(event);
        break;
      default:
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
    yield ForumLoadInProgress();
    final forums = await repo.getForums();
    final categories = ['Category1', 'Category2', 'Category3'];
    yield ForumLoadSuccess(forums: forums, categories: categories);
  }

  Stream<ForumState> _mapAddForumEventToState(AddForum event) async* {
    if (state is ForumLoadSuccess) {
      final curState = (state as ForumLoadSuccess);
      yield ForumLoadInProgress();

      // Add images
      final imgUrls = <String>[];
      for (final f in event.images) {
        final url = await repo.uploadImage(f.file);
        imgUrls.add(url);
      }
      final user = await repo.getUser();

      final nForum = event.forum.copyWith(
        imageUrls: imgUrls,
        addedById: user.id,
        addedByType: user.type,
        addedByAvatar: user.avatar,
        addedByName: user.fullname,
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
      final imgUrls = <String>[];
      for (final f in event.images) {
        if (f.source == PhotoSource.File) {
          final url = await repo.uploadImage(f.file);
          imgUrls.add(url);
        } else {
          imgUrls.add(f.url);
        }
      }

      final nForum = event.forum.copyWith(
        imageUrls: imgUrls,
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
