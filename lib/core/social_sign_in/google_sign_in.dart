import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:covidoc/core/error/failures.dart';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final googleUser = await GoogleSignIn().signIn();

  if (googleUser == null) {
    throw ServerFailure('Login cancelled by user');
  }

  // Obtain the auth details from the request
  final googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> signOutWithGoogle() async {
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
}
