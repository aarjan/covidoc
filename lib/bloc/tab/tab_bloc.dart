import 'package:bloc/bloc.dart';
import 'package:covidoc/bloc/tab/tab.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(TabState.DASHBOARD);

  @override
  Stream<TabState> mapEventToState(TabEvent event) async* {
    if (event is OnTabChanged) {
      switch (event.index) {
        case 0:
          yield TabState.DASHBOARD;
          break;
        case 1:
          yield TabState.CHAT;
          break;
        case 2:
          yield TabState.FORUM;
          break;
        case 3:
          yield TabState.PROFILE;
          break;
        default:
          throw UnimplementedError('Tab index not found');
      }
    }
  }
}
