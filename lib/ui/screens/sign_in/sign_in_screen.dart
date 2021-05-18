import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/ui/router.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';

class SignInScreen extends StatelessWidget {
  static const ROUTE_NAME = '/signIn';
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sign In', style: AppFonts.BOLD_WHITE_18),
      ),
      body: BlocConsumer<SignInBloc, SignInState>(
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
        builder: (context, state) {
          return Stack(
            children: [
              IgnorePointer(
                ignoring: state is SignInProgress,
                child: const SignInView(),
              ),
              if (state is SignInProgress)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
}

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'Sign in and unlock special features!',
            style: AppFonts.SEMIBOLD_BLACK3_18,
          ),
          const SizedBox(
            height: 20,
          ),
          const PlanDescription(text: 'Communicate with Doctors in real time'),
          const PlanDescription(text: 'Participate in the discussion'),
          const PlanDescription(text: 'Get notified of your queries'),
          const SizedBox(
            height: 40,
          ),
          Center(
            child: SignInButton(
              Buttons.FacebookNew,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(15),
              onPressed: () async {
                context
                    .read<SignInBloc>()
                    .add(SignInStarted(SignInType.Facebook));
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SignInButton(
              Buttons.Google,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(15),
              onPressed: () async {
                context
                    .read<SignInBloc>()
                    .add(SignInStarted(SignInType.Google));
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SignInButton(
              Buttons.Twitter,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(15),
              onPressed: () async {
                context
                    .read<SignInBloc>()
                    .add(SignInStarted(SignInType.Twitter));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlanDescription extends StatelessWidget {
  const PlanDescription({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.WHITE3,
              size: 18,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              softWrap: true,
              style: AppFonts.REGULAR_BLACK3_14,
            ),
          ],
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
