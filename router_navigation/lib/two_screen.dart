import 'package:flutter/material.dart';

class TwoScreen extends StatelessWidget {
  const TwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two Screen'),
      ),
      body: const Center(
        child: Text('Welcome to Two Screen!'),
      ),
    );
  }
}
