import 'package:covidoc/model/bloc/bloc.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInFailure) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is SignInSuccess) {
            if (state.profileVerification) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()));
            } else
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()));
          }
        },
        child: SignInView(),
      ),
    );
  }
}

class SignInView extends StatelessWidget {
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
          const SizedBox(height: 20),
          SignInButton(Buttons.Google, onPressed: () async {
            context.read<SignInBloc>().add(SignInStarted());
          }),
        ],
      ),
    );
  }
}
