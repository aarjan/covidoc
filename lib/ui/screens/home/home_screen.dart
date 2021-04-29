import 'package:flutter/material.dart';
import 'package:covidoc/model/bloc/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
        child: HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome to Covidoc!',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(LoggedOut());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
