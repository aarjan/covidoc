import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:covidoc/ui/screens/screens.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case BlogScreen.ROUTE_NAME:
        return getRoute(const BlogScreen());
      case HomeScreen.ROUTE_NAME:
        return getRoute(const HomeScreen());
      case SignInScreen.ROUTE_NAME:
        return getRoute(const SignInScreen());
      case ForumScreen.ROUTE_NAME:
        return getRoute(const ForumScreen());
      case ProfileScreen.ROUTE_NAME:
        return getRoute(const ProfileScreen());
      case RegisterScreen.ROUTE_NAME:
        return getRoute(const RegisterScreen());
      case CovidStatusScreen.ROUTE_NAME:
        return getRoute(const CovidStatusScreen());
      case CovidSymptomScreen.ROUTE_NAME:
        return getRoute(const CovidSymptomScreen());
      case PatientDescScreen.ROUTE_NAME:
        return getRoute(const PatientDescScreen());
      case DocChatListScreen.ROUTE_NAME:
        return getRoute(const DocChatListScreen());
      case ChatScreen.ROUTE_NAME:
        return getRoute(const ChatScreen());
      case DashboardScreen.ROUTE_NAME:
        return getRoute(const DashboardScreen());
      case ForumDiscussScreen.ROUTE_NAME:
        return getRoute(const ForumDiscussScreen());
      case UserProfileScreen.ROUTE_NAME:
        return getRoute(const UserProfileScreen());
      default:

        /// [TODO]: Show 404 page
        throw UnimplementedError('No route defined for ${settings.name}');
    }
  }
}

Route getRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
          .chain(CurveTween(curve: Curves.easeIn));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
