import 'dart:async';
import 'package:flutter/material.dart';
import './ui/login_screen.dart';
import './ui/jobs.dart';

void main() {
  runApp(new MaterialApp(
    title: "CASE IT",
    initialRoute: googleSignIn.currentUser == null ? '/' : '/jobs',
    routes: {
      '/'     : (context) => Login(),
      '/disclaimer' : (context) => Disclaimer(),
      '/jobs' : (context) => Jobs(),
      '/jobDetails' : (context) => JobDetails(),
    },
  ));
}