import 'package:flutter/material.dart';
import 'first.dart';
import 'second.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Main",
      initialRoute: '/',
      routes: {
        '/': (context) => FirstScreen(),
        '/two': (context) => SecondScreen(),
      },
    );
  }
}
