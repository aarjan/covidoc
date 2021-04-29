import 'package:covidoc/model/repo/repo.dart';
import 'package:flutter/material.dart';
import 'package:covidoc/model/bloc/bloc.dart';
import 'package:covidoc/model/local/pref.dart';
import 'package:covidoc/ui/screens/screens.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.DEFAULT,
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
        appBarTheme: const AppBarTheme(color: AppColors.DEFAULT),
      ),
      initialRoute: '/',
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case Authenticated:
              return (state as Authenticated).profileVerification
                  ? const DashboardScreen()
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

  final authBloc = AuthBloc(AuthRepo(sessionRepo));

  final userRepo = UserRepo(sessionRepo);

  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => authBloc..add(AppStarted()),
      ),
      BlocProvider(
        create: (_) => UserBloc(repo: userRepo),
      ),
      BlocProvider(
        create: (_) => SignInBloc(SignInRepo(sessionRepo), authBloc),
      )
    ],
    child: const App(),
  );
}
