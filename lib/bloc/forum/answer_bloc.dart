import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/forum_repo.dart';

class AnswerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AnswerState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadAnswers extends AnswerEvent {
  final Forum question;

  LoadAnswers(this.question);
}

class AddAnswer extends AnswerEvent {
  final Answer answer;
  final List<Photo> images;

  AddAnswer({this.answer, this.images});

  @override
  List<Object> get props => [answer, images];
}

class UpdateAnswer extends AnswerEvent {
  final Answer answer;
  final List<Photo> images;
  UpdateAnswer({this.answer, this.images});

  @override
  List<Object> get props => [answer, images];
}

class DeleteAnswer extends AnswerEvent {
  final String forumId;
  final String answerId;
  DeleteAnswer(this.forumId, this.answerId);

  @override
  List<Object> get props => [forumId, answerId];
}

class AnswerInitial extends AnswerState {}

class AnswerLoadInProgress extends AnswerState {}

class AnswerLoadSuccess extends AnswerState {
  final Forum question;
  final List<Answer> answers;
  final bool answerUpdated;
  final List<String> uploadedImgUrls;

  AnswerLoadSuccess({
    this.answers,
    this.question,
    this.uploadedImgUrls,
    this.answerUpdated = false,
  });

  @override
  List<Object> get props => [answers, uploadedImgUrls, question, answerUpdated];

  AnswerLoadSuccess copyWith({
    Forum question,
    bool answerUpdated,
    List<Answer> answers,
    List<String> uploadedImgUrls,
  }) {
    return AnswerLoadSuccess(
      answers: answers ?? this.answers,
      question: question ?? this.question,
      answerUpdated: answerUpdated ?? this.answerUpdated,
      uploadedImgUrls: uploadedImgUrls ?? this.uploadedImgUrls,
    );
  }
}

class AnswerLoadFailure extends AnswerState {
  final String error;
  AnswerLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AnswerBloc extends Bloc<AnswerEvent, AnswerState> {
  final ForumRepo repo;
  AnswerBloc(this.repo) : super(AnswerInitial());

  @override
  Stream<AnswerState> mapEventToState(AnswerEvent event) async* {
    switch (event.runtimeType) {
      case LoadAnswers:
        yield* _mapLoadAnswersEventToState(event);
        break;
      case AddAnswer:
        yield* _mapAddAnswerEventToState(event);
        break;
      case DeleteAnswer:
        yield* _mapDeleteAnswerEventToState(event);
        break;
      case UpdateAnswer:
        yield* _mapUpdateAnswerEventToState(event);
        break;
      default:
    }
  }

  Stream<AnswerState> _mapLoadAnswersEventToState(LoadAnswers event) async* {
    yield AnswerLoadInProgress();
    final answers = await repo.getAnswers(event.question.id);
    yield AnswerLoadSuccess(question: event.question, answers: answers);
  }

  Stream<AnswerState> _mapAddAnswerEventToState(AddAnswer event) async* {
    if (state is AnswerLoadSuccess) {
      final curState = state as AnswerLoadSuccess;

      yield AnswerLoadInProgress();

      // Add images
      final imgUrls = <String>[];
      for (final f in event.images) {
        final url = await repo.uploadImage(f.file);
        imgUrls.add(url);
      }

      final user = await repo.getUser();

      final nAnswer = event.answer.copyWith(
        imageUrls: imgUrls,

        // user data
        addedById: user.id,
        addedByType: user.type,
        addedByAvatar: user.avatar,
        addedByName: user.fullname,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      final addUserAvatar = curState.question.recentUsersAvatar.length < 4;

      final answer = await repo.addAnswer(nAnswer, addUserAvatar);

      final nAns = List<Answer>.from([...curState.answers, answer]);
      yield curState.copyWith(
          answers: nAns,
          question: curState.question
              .copyWith(ansCount: curState.question.ansCount + 1));
    }
  }

  Stream<AnswerState> _mapUpdateAnswerEventToState(UpdateAnswer event) async* {
    if (state is AnswerLoadSuccess) {
      final curState = state as AnswerLoadSuccess;
      yield AnswerLoadInProgress();

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

      final nAnswer = event.answer.copyWith(
        imageUrls: imgUrls,
        updatedAt: DateTime.now().toUtc(),
      );

      await repo.updateAnswer(nAnswer);

      yield curState.copyWith(
          answers: curState.answers
              .map((a) => a.id == event.answer.id ? nAnswer : a)
              .toList());
    }
  }

  Stream<AnswerState> _mapDeleteAnswerEventToState(DeleteAnswer event) async* {
    if (state is AnswerLoadSuccess) {
      final curState = state as AnswerLoadSuccess;
      yield AnswerLoadInProgress();

      await repo.delAnswer(event.forumId, event.answerId);

      //[TODO:] remove currentAvatar from recentUsersAvatar
      final nAnswers =
          curState.answers.where((f) => f.id != event.answerId).toList();

      yield curState.copyWith(answers: nAnswers);
    }
  }
}
