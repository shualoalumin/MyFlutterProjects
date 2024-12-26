import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String result = '';

  
  Future<void> fetchData() async {
    final Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          result = response.body; 
        });
      } else {
        setState(() {
          result = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e'; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HTTP GET Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(result, textAlign: TextAlign.center), 
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchData,
                child: const Text('Send GET Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
