import 'package:equatable/equatable.dart';

class TabEvent extends Equatable {
  const TabEvent();

  @override
  List<Object> get props => [];
}

class OnTabChanged extends TabEvent {
  final int index;

  const OnTabChanged(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() {
    return 'onTabChanged: { index: $index }';
  }
}
