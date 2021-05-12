import 'package:covidoc/env.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class TwitterSignIn {
  // Create a TwitterLogin instance
  static final twitterLogin = TwitterLogin(
    consumerKey: APP_ENV['TWITTER_API_KEY'],
    consumerSecret: APP_ENV['TWITTER_API_SECRET'],
  );

  static Future<UserCredential> signInWithTwitter() async {
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

  static Future signOutWithTwitter() async {
    await twitterLogin.logOut();
    await FirebaseAuth.instance.signOut();
  }
}
