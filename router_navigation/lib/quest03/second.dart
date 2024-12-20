import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the argument passed from the first screen
    final bool isCat = ModalRoute.of(context)!.settings.arguments as bool;

    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
        leading: Icon(Icons.pets),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Back"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print('is_cat: $isCat');
              },
              child: Image.asset(
                'assets/pic/1.jpg',
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
