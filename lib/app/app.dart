import 'package:covidoc/model/repo/blog_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/ui/router.dart';
import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/model/repo/repo.dart';
import 'package:covidoc/model/local/pref.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/screens/screens.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.DEFAULT,
        accentColor: AppColors.DEFAULT,
        dividerTheme: const DividerThemeData(
            color: AppColors.WHITE4, thickness: 1, space: 0),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
            textStyle: AppFonts.SEMIBOLD_WHITE_16,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: AppColors.DEFAULT,
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 1,
          color: AppColors.WHITE,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case Authenticated:
              return (state as Authenticated).profileVerification
                  ? const HomeScreen()
                  : const RegisterScreen();
              break;
            case UnAuthenticated:
              return const SignInScreen();
              break;
            default:
              return const SplashScreen();
          }
        },
      ),
    );
  }
}

Widget runWidget() {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionRepo = SessionRepository(LocalPref());

  final userRepo = UserRepo(sessionRepo);
  final blogRepo = BlogRepo(sessionRepo);
  final msgRepo = MessageRepo(sessionRepo);
  final forumRepo = ForumRepo(sessionRepo);

  final authBloc = AuthBloc(AuthRepo(sessionRepo))..add(AppStarted());

  final userBloc = UserBloc(repo: userRepo, authBloc: authBloc);

  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (_) => msgRepo),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => authBloc),
        BlocProvider(create: (_) => userBloc),
        BlocProvider(
          create: (_) => SignInBloc(SignInRepo(sessionRepo), authBloc),
        ),
        BlocProvider(
          create: (context) => MessageBloc(repo: msgRepo),
        ),
        BlocProvider(
          create: (context) => BlogBloc(blogRepo),
        ),
        BlocProvider(
          create: (context) => ChatBloc(repo: msgRepo),
        ),
        BlocProvider(
          create: (context) => ForumBloc(forumRepo),
        ),
        BlocProvider(
          create: (context) => AnswerBloc(forumRepo),
        ),
      ],
      child: const App(),
    ),
  );
}
