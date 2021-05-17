import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/ui/router.dart';
import 'package:covidoc/ui/screens/screens.dart';

class SignInScreen extends StatelessWidget {
  static const ROUTE_NAME = '/signIn';
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is SignInSuccess) {
            if (state.profileVerification) {
              Navigator.pushReplacement(
                  context, getRoute(const HomeScreen(isAuthenticated: true)));
            } else
              Navigator.pushReplacementNamed(
                  context, RegisterScreen.ROUTE_NAME);
          }
        },
        child: const SignInView(),
      ),
    );
  }
}

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Sign In with Google!',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 20,
          ),
          SignInButton(Buttons.Google, onPressed: () async {
            context.read<SignInBloc>().add(SignInStarted(SignInType.Google));
          }),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Sign In with Facebook!',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 20,
          ),
          SignInButton(Buttons.FacebookNew, onPressed: () async {
            context.read<SignInBloc>().add(SignInStarted(SignInType.Facebook));
          }),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Sign In with Twitter!',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 20,
          ),
          SignInButton(Buttons.Twitter, onPressed: () async {
            context.read<SignInBloc>().add(SignInStarted(SignInType.Twitter));
          }),
        ],
      ),
    );
  }
}
