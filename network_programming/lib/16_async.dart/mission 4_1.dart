import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('미션 4-1 Stream.periodic'),
        ),
        body: NumberStreamWidget(),
      ),
    );
  }
}

class NumberStreamWidget extends StatelessWidget {
  final Stream<int> numberStream = Stream.periodic(
    Duration(seconds: 1),
    (count) => count,
  );

  NumberStreamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<int>(
        stream: numberStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(
              'Waiting for data...',
              style: TextStyle(fontSize: 20),
            );
          } else if (snapshot.hasData) {
            return Text(
              'Number: ${snapshot.data}',
              style: TextStyle(fontSize: 30),
            );
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 20, color: Colors.red),
            );
          } else {
            return Text(
              'No data',
              style: TextStyle(fontSize: 20),
            );
          }
        },
      ),
    );
  }
}
