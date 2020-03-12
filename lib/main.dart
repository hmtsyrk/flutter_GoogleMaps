import 'package:flutter/material.dart';
import 'package:flutter_map/src/app.dart';
import 'package:flutter_map/src/blocs/auth_bloc.dart';
import 'package:flutter_map/src/resource/login_page.dart';

void main() {
  runApp(ArjCar(
      new AuthBloc(),
      MaterialApp(
        home: LoginPage(),
      )));
}
