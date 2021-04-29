import 'package:bloc/bloc.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/user_repo.dart';
import 'package:equatable/equatable.dart';

class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUser extends UserEvent {}

class UpdateUser extends UserEvent {
  final AppUser user;
  final bool persist;

  UpdateUser({this.user, this.persist = false});

  @override
  List<Object> get props => [persist];
}

class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoadSuccess extends UserState {
  final AppUser user;

  UserLoadSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class UserLoadInProgress extends UserState {}

class UserLoadFailure extends UserState {}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo repo;
  UserBloc({this.repo}) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(event) async* {
    switch (event.runtimeType) {
      case LoadUser:
        yield* _mapLoadUserEventToState();
        break;
      case UpdateUser:
        yield* _mapUpdateUserEventToState(event);
        break;
      default:
    }
  }

  Stream<UserState> _mapLoadUserEventToState() async* {
    yield UserLoadInProgress();
    final user = await repo.getUser();
    yield UserLoadSuccess(user);
  }

  Stream<UserState> _mapUpdateUserEventToState(UpdateUser event) async* {
    AppUser cUser;
    yield UserLoadInProgress();

    if (state is UserLoadSuccess) {
      cUser = (state as UserLoadSuccess).user;
    } else {
      cUser = await repo.getUser();
    }

    final nUser = cUser.copyUser(event.user);
    if (event.persist) {
      await repo.updateUser(nUser);
    }
    yield UserLoadSuccess(nUser);
  }
}
