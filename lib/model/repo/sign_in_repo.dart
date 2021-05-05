import 'package:flutter/foundation.dart';
import 'package:either_option/either_option.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:covidoc/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:covidoc/model/entity/app_user.dart';
import 'package:covidoc/model/repo/session_repo.dart';
import 'package:covidoc/bloc/sign_in/sign_in_event.dart';
import 'package:covidoc/core/social_sign_in/social_signin.dart';

class SignInRepo {
  final SessionRepository sessionRepo;

  SignInRepo(this.sessionRepo);

  Future<Either<ServerFailure, AppUser>> signIn(SignInType type) async {
    try {
      UserCredential userCreds;
      switch (type) {
        case SignInType.Facebook:
          userCreds = await signInWithFacebook();
          break;
        case SignInType.Google:
          userCreds = await signInWithGoogle();
          break;
        case SignInType.Twitter:
          userCreds = await signInWithTwitter();
          break;
        default:
      }

      final user = AppUser(
        type: 'Patient',
        email: userCreds.user.email ?? userCreds.user.providerData[0].email,
        avatar: userCreds.user.photoURL,
        fullname: userCreds.user.displayName,
        providerId: {
          describeEnum(type): userCreds.user.providerData[0].uid,
        },
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<AppUser> storeUser(AppUser user, SignInType type) async {
    final _type = describeEnum(type);
    try {
      // Find user by providerId
      final firestore = FirebaseFirestore.instance;
      final uRef = await firestore
          .collection('user')
          .where('providerId.$_type', isEqualTo: user.providerId.values.first)
          .get();

      // Create new user if not exists
      if (uRef == null || uRef.docs.isEmpty) {
        final userRef = await firestore.collection('user').add(user.toJson());
        final fUser = user.copyWith(id: userRef.id);

        await cacheUserInfo(fUser, type);
        return fUser;
      }

      final fUser = AppUser.fromJson(uRef.docs[0].data());

      // Add providerId if not exists
      if (!fUser.providerId.containsKey(user.providerId.keys.first)) {
        fUser.providerId[_type] = user.providerId[_type];

        await firestore
            .doc('user/${fUser.id}')
            .update({'providerId': fUser.providerId});
      }

      await cacheUserInfo(fUser, type);
      return fUser;
    } catch (e) {
      return e;
    }
  }

  Future<void> cacheUserInfo(AppUser user, SignInType type) async {
    await sessionRepo.cacheUser(user);
    await sessionRepo.cacheSignInType(describeEnum(type));
  }
}
