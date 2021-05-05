import 'package:either_option/either_option.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:covidoc/core/error/failures.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/session_repo.dart';
import 'package:covidoc/core/social_sign_in/social_signin.dart';

class AuthRepo {
  final SessionRepository sessionRepo;

  AuthRepo(this.sessionRepo);

  Future<Either<ServerFailure, void>> signOut() async {
    try {
      final type = await sessionRepo.getSignInType();
      switch (type) {
        case 'Facebook':
          await signOutWithFacebook();
          break;
        case 'Google':
          await signOutWithGoogle();
          break;
        case 'Twitter':
          await signOutWithTwitter();
          break;
        default:
      }

      await sessionRepo.flushAll();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<bool> isSignedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }
    return true;
  }

  Future<AppUser> getUser() async {
    return sessionRepo.getUser();
  }
}
