// @dart=2.9
import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:covidoc/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:covidoc/app/app_bloc_observer.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await Firebase.initializeApp();

  runZonedGuarded(
    () => runApp(runWidget()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
