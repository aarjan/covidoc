import 'package:bloc/bloc.dart';
import 'package:covidoc/model/repo/home_repo.dart';

import 'home.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.repo) : super(HomeInitial());
  final HomeRepo repo;

  @override
  Stream<HomeState> mapEventToState(event) async* {
    try {
      switch (event.runtimeType) {
        case LoadHome:
          break;
        case Logout:
          await repo.googleSignOut();
          break;
        default:
      }
    } catch (e) {
      yield HomeLoadFailure(e.toString());
    }
  }
}
