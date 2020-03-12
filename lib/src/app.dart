import 'package:flutter/material.dart';
import 'package:flutter_map/src/blocs/auth_bloc.dart';

class ArjCar extends InheritedWidget {
  final AuthBloc autoBloc;
  final Widget child;
  ArjCar(this.autoBloc, this.child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return null;
  }

  static ArjCar of(BuildContext context){
    // return context.inheritFromWidgetOfExactType(ArjCar); // eski versiyon kodu
    return context.dependOnInheritedWidgetOfExactType<ArjCar>();
  }
}
