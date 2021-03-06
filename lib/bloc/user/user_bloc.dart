import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covidoc/bloc/auth/auth.dart';
import 'package:covidoc/bloc/auth/auth_bloc.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/user_repo.dart';
import 'package:equatable/equatable.dart';

class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  final String? userId;

  LoadUser({this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadUsers extends UserEvent {}

class ClearUser extends UserEvent {}

class UpdateUser extends UserEvent {
  final AppUser? user;
  final bool persist;

  UpdateUser({this.user, this.persist = false});

  @override
  List<Object> get props => [persist];
}

class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoadSuccess extends UserState {
  final AppUser user;
  final bool userUpdated;
  final List<AppUser> doctors;

  UserLoadSuccess(
      {required this.user, this.userUpdated = false, this.doctors = const []});

  @override
  List<Object?> get props => [user, doctors, userUpdated];

  UserLoadSuccess copyWith(
      {AppUser? user, List<AppUser>? doctors, bool? userUpdated}) {
    return UserLoadSuccess(
      user: this.user,
      doctors: doctors ?? this.doctors,
      userUpdated: userUpdated ?? this.userUpdated,
    );
  }
}

class UserLoadInProgress extends UserState {}

class UserLoadFailure extends UserState {}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo repo;
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  UserBloc({required this.authBloc, required this.repo})
      : super(UserInitial()) {
    authSubscription = authBloc.stream.listen((state) {
      if (state is Authenticated) {
        add(LoadUser());
      }
    });
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }

  @override
  Stream<UserState> mapEventToState(event) async* {
    switch (event.runtimeType) {
      case LoadUser:
        yield* _mapLoadUserEventToState(event as LoadUser);
        break;
      case UpdateUser:
        yield* _mapUpdateUserEventToState(event as UpdateUser);
        break;
      case LoadUsers:
        yield* _mapLoadUsersEventToState(event as LoadUsers);
        break;
      case ClearUser:
        yield UserInitial();
        break;
      default:
    }
  }

  Stream<UserState> _mapLoadUserEventToState(LoadUser event) async* {
    yield UserLoadInProgress();
    AppUser? user;
    if (event.userId != null) {
      user = await repo.loadUser(event.userId);
    } else {
      user = await repo.getUser();
    }
    yield UserLoadSuccess(user: user!);
  }

  Stream<UserState> _mapUpdateUserEventToState(UpdateUser event) async* {
    yield UserLoadInProgress();

    final cUser = (await repo.getUser()) ?? const AppUser();

    final nUser = cUser.copyUser(event.user!);
    await repo.cacheUser(nUser);

    if (event.persist) {
      await repo.updateUser(nUser);
    }

    yield UserLoadSuccess(user: nUser, userUpdated: true);
  }

  Stream<UserState> _mapLoadUsersEventToState(LoadUsers event) async* {
    final user = await (repo.getUser() as FutureOr<AppUser>);

    yield UserLoadInProgress();
    final doctors = await repo.loadUsers(
        userId: user.id, userIds: user.chatUsers, userType: user.type);
    yield UserLoadSuccess(doctors: doctors, user: user);
  }
}
