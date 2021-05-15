import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/app_user.dart';

class HomeScreen extends StatelessWidget {
  static const ROUTE_NAME = '/home';

  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabBloc()..add(const OnTabChanged(0)),
      child: BlocBuilder<TabBloc, TabState>(
        builder: (context, state) {
          final user = context.select((UserBloc b) =>
              (b.state is UserLoadSuccess)
                  ? (b.state as UserLoadSuccess).user
                  : null);

          return Scaffold(
            body: Builder(builder: (context) {
              switch (state) {
                case TabState.DASHBOARD:
                  return const DashboardScreen();
                  break;
                case TabState.CHAT:
                  return user.type == describeEnum(UserType.Doctor)
                      ? const DocChatListScreen()
                      : const PatChatListScreen();
                  break;
                case TabState.FORUM:
                  return const ForumScreen();
                  break;
                case TabState.PROFILE:
                  return const ProfileScreen();
                  break;
                default:
                  throw UnimplementedError();
              }
            }),
            bottomNavigationBar: BottomNavBar(
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
