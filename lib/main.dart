// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'weather_page.dart';
import 'weather_service.dart';
import 'weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: WeatherPage());
  }
}
