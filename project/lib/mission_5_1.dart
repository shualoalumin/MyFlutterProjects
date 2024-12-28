import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter & FastAPI')),
        body: Center(
          child: FutureBuilder(
            future: fetchGreeting(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Response: ${snapshot.data}');
              }
            },
          ),
        ),
      ),
    );
  }

  Future<String> fetchGreeting() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['Hello'];
    } else {
      throw Exception('Failed to load greeting');
    }
  }
}
