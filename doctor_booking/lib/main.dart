import 'package:flutter/material.dart';

import 'pages/splash.dart';
import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/register.dart';
import 'pages/appointments.dart';


void main() => runApp(MaterialApp(
  home: Splash(),
  debugShowCheckedModeBanner: false,
  routes: {
    'login': (context) => Login(),
    'register': (context) => Register(),
    'home': (context) => Home(),
    'appointments' : (context) => Appointments(),
  },
  theme: new ThemeData(
    primaryColor: Color(0xFF132937),
    primaryColorLight: Color(0xFF347298),
    primaryColorDark: Color(0xFF010815),
    accentColor:  Color(0xFFde5d83),
  ),
)
);