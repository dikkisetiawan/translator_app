import 'package:flutter/material.dart';
import 'package:translator_app/screens/splash_page.dart';
import 'screens/choose_page.dart';
import 'screens/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SecondPage(),
    );
  }
}
