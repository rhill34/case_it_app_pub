import 'dart:async';
import 'package:flutter/material.dart';
import './ui/login_screen.dart';
import './ui/jobs.dart';
import './ui/calendar.dart';

void main() {
  runApp(new MaterialApp(
    title: "CASE IT",
    debugShowCheckedModeBanner: false,
    // initialRoute: googleSignIn.currentUser == null ? '/' : '/cal',
    initialRoute: '/cal',
    routes: {
      '/'     : (context) => Login(),
      '/cal' : (context) => KalPage(title: "CASE IT"),
      '/disclaimer' : (context) => Disclaimer(),
      '/jobs' : (context) => Jobs(),
      '/jobDetails' : (context) => JobDetails(),
      

    },
  ));
}