import 'package:bloc/bloc.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/user_repo.dart';
import 'package:equatable/equatable.dart';

class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUser extends UserEvent {}

class LoadUsers extends UserEvent {}

class ClearUser extends UserEvent {}

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
  final List<AppUser> doctors;

  UserLoadSuccess({this.user, this.doctors = const []});

  @override
  List<Object> get props => [user, doctors];

  UserLoadSuccess copyWith({user, doctors}) {
    return UserLoadSuccess(user: this.user, doctors: doctors ?? this.doctors);
  }
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
      case LoadUsers:
        yield* _mapLoadUsersEventToState(event);
        break;
      case ClearUser:
        yield UserInitial();
        break;
      default:
    }
  }

  Stream<UserState> _mapLoadUserEventToState() async* {
    yield UserLoadInProgress();
    final user = await repo.getUser();
    yield UserLoadSuccess(user: user);
  }

  Stream<UserState> _mapUpdateUserEventToState(UpdateUser event) async* {
    yield UserLoadInProgress();

    final cUser = (await repo.getUser()) ?? const AppUser();

    final nUser = cUser.copyUser(event.user);
    await repo.cacheUser(nUser);

    if (event.persist) {
      await repo.updateUser(nUser);
    }

    yield UserLoadSuccess(user: nUser);
  }

  Stream<UserState> _mapLoadUsersEventToState(LoadUsers event) async* {
    final user = await repo.getUser();

    yield UserLoadInProgress();
    final doctors = await repo.loadUsers(
        userId: user.id, userIds: user.chatUsers, userType: user.type);
    yield UserLoadSuccess(doctors: doctors, user: user);
  }
}
