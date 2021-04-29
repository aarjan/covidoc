import 'package:bloc/bloc.dart';
import 'package:covidoc/bloc/auth/auth.dart';
import 'package:covidoc/model/repo/sign_in_repo.dart';

import 'sign_in.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(this.repo, this.authBloc) : super(SignInInitial());
  final SignInRepo repo;
  final AuthBloc authBloc;

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    try {
      switch (event.runtimeType) {
        case SignInStarted:
          final resp = await repo.googleSign();
          yield* resp.fold(
            (f) async* {
              yield SignInFailure(f.toString());
            },
            (user) async* {
              final nUser = await repo.storeUser(user);
              authBloc.add(
                LoggedIn(profileVerification: nUser.profileVerification),
              );
              yield SignInSuccess(
                profileVerification: nUser.profileVerification,
              );
            },
          );
          break;
        default:
      }
    } catch (e) {
      yield SignInFailure(e.toString());
    }
  }
}
