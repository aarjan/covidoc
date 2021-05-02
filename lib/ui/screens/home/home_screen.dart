import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/ui/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const ROUTE_NAME = '/home';

  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabBloc()..add(const OnTabChanged(0)),
      child: BlocBuilder<TabBloc, TabState>(
        builder: (context, state) {
          return Scaffold(
            body: Builder(builder: (context) {
              switch (state) {
                case TabState.DASHBOARD:
                  return const DashboardScreen();
                  break;
                case TabState.CHAT:
                  return const ChatListScreen();
                  break;
                case TabState.GUIDELINES:
                  return ForumScreen();
                  break;
                case TabState.PROFILE:
                  return Container();
                  break;
                default:
                  throw UnimplementedError();
              }
            }),
            bottomNavigationBar: BottomNavBar(
              onSelected: (index) {
                context.read<TabBloc>().add(OnTabChanged(index));

                if (index == 3) {
                  context.read<AuthBloc>().add(LoggedOut());
                  context.read<UserBloc>().add(ClearUser());
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
            ),
          );
        },
      ),
    );
  }
}
