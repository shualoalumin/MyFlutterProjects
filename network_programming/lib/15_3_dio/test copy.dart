import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DIO Example'),
        ),
        body: const DioExample(),
      ),
    );
  }
}

class DioExample extends StatefulWidget {
  const DioExample({super.key});

  @override
  State<DioExample> createState() => _DioExampleState();
}

class _DioExampleState extends State<DioExample> {
  String result = '';

  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.path}');
        options.headers['Authorization'] = 'Bearer YOUR_TOKEN_HERE';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Future<void> fetchData() async {
    try {
      final response = await dio.get('posts/1');
      setState(() {
        result = response.data.toString();
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
