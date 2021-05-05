import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

Future<UserCredential> signInWithTwitter() async {
  // Create a TwitterLogin instance
  final twitterLogin = TwitterLogin(
    consumerKey: 'DXGMtogow1D1Nta7xFoO22T8T',
    consumerSecret: 'n8Ty6tdckqybahFzAL5saRwyuqYOloBUPzZ3dzDbqfbkUqO2RS',
  );

  // Trigger the sign-in flow
  final result = await twitterLogin.authorize();

  // Get the Logged In session
  final twitterSession = result.session;

  // Create a credential from the access token
  final twitterAuthCredential = TwitterAuthProvider.credential(
    accessToken: twitterSession.token,
    secret: twitterSession.secret,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance
      .signInWithCredential(twitterAuthCredential);
}

Future signOutWithTwitter() async {
  await FirebaseAuth.instance.signOut();
}
