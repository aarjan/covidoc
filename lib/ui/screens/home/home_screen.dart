import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/app_user.dart';

class HomeScreen extends StatelessWidget {
  final bool isAuthenticated;
  static const ROUTE_NAME = '/home';

  const HomeScreen({Key? key, this.isAuthenticated = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserBloc b) => (b.state is UserLoadSuccess)
        ? (b.state as UserLoadSuccess).user
        : null);

    return BlocProvider(
      create: (context) => TabBloc()..add(const OnTabChanged(0)),
      child: BlocBuilder<TabBloc, TabState>(
        builder: (context, state) {
          return Scaffold(
            body: Builder(builder: (context) {
              switch (state) {
                case TabState.DASHBOARD:
                  return DashboardScreen(
                    user: user,
                  );
                case TabState.CHAT:
                  return user == null ||
                          user.type == describeEnum(UserType.Patient)
                      ? PatChatListScreen(
                          isAuthenticated: isAuthenticated,
                        )
                      : const DocChatListScreen();

                case TabState.FORUM:
                  return ForumScreen(
                    isAuthenticated: isAuthenticated,
                  );
                case TabState.PROFILE:
                  return ProfileScreen(
                    isAuthenticated: isAuthenticated,
                  );
                default:
                  throw UnimplementedError();
              }
            }),
            bottomNavigationBar: BottomNavBar(
              selectedIndex: state.index,
              onSelected: (index) {
                context.read<TabBloc>().add(OnTabChanged(index));
              },
            ),
          );
        },
      ),
    );
  }
}
