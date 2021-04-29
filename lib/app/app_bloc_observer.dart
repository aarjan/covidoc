import 'dart:developer';

import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('onTransition(${bloc.runtimeType}, $transition)');
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    log('onError(${cubit.runtimeType}, $error, $stackTrace)');
    super.onError(cubit, error, stackTrace);
  }
}
