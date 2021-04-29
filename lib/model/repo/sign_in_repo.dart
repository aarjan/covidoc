import 'package:either_option/either_option.dart';
import 'package:covidoc/model/entity/app_user.dart';
import 'package:covidoc/model/repo/session_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:covidoc/core/error/failures.dart';
import 'package:covidoc/core/social_sign_in/google_signin.dart';

class SignInRepo {
  final SessionRepository sessionRepo;

  SignInRepo(this.sessionRepo);

  Future<Either<ServerFailure, AppUser>> googleSign() async {
    try {
      final userCreds = await signInWithGoogle();
      final user = AppUser(
        type: 'Patient',
        email: userCreds.user.email,
        avatar: userCreds.user.photoURL,
        fullname: userCreds.user.displayName,
        providerId: userCreds.user.providerData[0].uid,
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<AppUser> storeUser(AppUser user) async {
    final firestore = FirebaseFirestore.instance;
    final fUser = await firestore
        .collection('user')
        .where('email', isEqualTo: user.email)
        .get();
    if (fUser == null || fUser.docs.isEmpty) {
      final userRef = await firestore.collection('user').add(user.toJson());
      final nUser = user.copyWith(id: userRef.id);
      await sessionRepo.cacheUser(nUser);
      return nUser;
    }
    final nUser = AppUser.fromJson(fUser.docs[0].data());
    await sessionRepo.cacheUser(nUser);
    return nUser;
  }
}
