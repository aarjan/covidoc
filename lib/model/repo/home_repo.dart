import 'package:either_option/either_option.dart';
import 'package:covidoc/core/error/failures.dart';
import 'package:covidoc/core/social_sign_in/google_signin.dart';

class HomeRepo {
  Future<Either<ServerFailure, void>> googleSignOut() async {
    try {
      await signOutWithGoogle();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
