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

class AddForum extends ForumEvent {
  final Forum forum;
  AddForum(this.forum);

  @override
  List<Object> get props => [forum];
}

class UpdateForum extends ForumEvent {
  final Forum forum;
  UpdateForum(this.forum);

  @override
  List<Object> get props => [forum];
}

class AddAnswer extends ForumEvent {
  final Answer answer;
  AddAnswer(this.answer);

  @override
  List<Object> get props => [answer];
}

class UpdateAnswer extends ForumEvent {
  final Answer answer;
  UpdateAnswer(this.answer);

  @override
  List<Object> get props => [answer];
}

class ForumInitial extends ForumState {}

class ForumLoadInProgress extends ForumState {}

class ForumLoadSuccess extends ForumState {
  final List<Forum> forums;

  ForumLoadSuccess(this.forums);
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
        yield ForumLoadInProgress();
        final forums = await repo.getForums();
        yield ForumLoadSuccess(forums);
        break;
      case UpdateForum:
        yield ForumLoadInProgress();
        await repo.updateForum((event as UpdateForum).forum);
        yield state as ForumLoadSuccess;
        break;
      case AddForum:
        yield ForumLoadInProgress();
        await repo.addForum((event as AddForum).forum);
        yield state as ForumLoadSuccess;
        break;
      case AddAnswer:
        yield ForumLoadInProgress();
        await repo.addAnswer((event as AddAnswer).answer);
        yield state as ForumLoadSuccess;
        break;
      case UpdateAnswer:
        yield ForumLoadInProgress();
        await repo.updateAnswer((event as UpdateAnswer).answer);
        yield state as ForumLoadSuccess;
        break;
      default:
    }
  }
}
