import 'package:flutter/material.dart';

class OneScreen extends StatelessWidget {
  const OneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One Screen'),
      ),
      body: const Center(
        child: Text('Welcome to One Screen!'),
      ),
    );
  }
}
