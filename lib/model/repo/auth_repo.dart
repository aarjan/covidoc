import 'package:covidoc/core/error/failures.dart';
import 'package:covidoc/core/social_sign_in/google_signin.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/model/repo/session_repo.dart';
import 'package:either_option/either_option.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final SessionRepository sessionRepo;

  AuthRepo(this.sessionRepo);

  Future<Either<ServerFailure, void>> signOut() async {
    try {
      await signOutWithGoogle();
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
