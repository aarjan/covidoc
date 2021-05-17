import 'package:bloc/bloc.dart';
import 'package:covidoc/model/repo/auth_repo.dart';

import 'auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.repo) : super(AuthInitial());
  final AuthRepo repo;

  @override
  Stream<AuthState> mapEventToState(event) async* {
    switch (event.runtimeType) {
      case LoggedIn:
        yield Authenticated(
          profileVerification: (event as LoggedIn).profileVerification,
        );
        break;
      case LoggedOut:
        yield AuthInProgress();
        await Future.delayed(const Duration(seconds: 2));
        await repo.signOut();
        yield UnAuthenticated();
        break;
      case AppStarted:
        yield AuthInProgress();
        await Future.delayed(const Duration(seconds: 2));
        final user = await repo.getUser();
        if (user != null) {
          yield Authenticated(
            profileVerification: user.profileVerification,
          );
        } else
          yield UnAuthenticated();
        break;
      default:
        yield UnAuthenticated();
    }
  }
}
