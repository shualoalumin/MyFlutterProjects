import 'package:flutter/material.dart';
import 'router.dart'; // Import the router file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: routes, // Use the routes defined in router.dart
    );
  }
}
