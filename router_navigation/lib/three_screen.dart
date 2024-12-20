import 'package:flutter/material.dart';

class ThreeScreen extends StatelessWidget {
  const ThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Three Screen'),
      ),
      body: const Center(
        child: Text('Welcome to Three Screen!'),
      ),
    );
  }
}
