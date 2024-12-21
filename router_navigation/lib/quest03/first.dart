import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool is_cat = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
        // leading: Icon(Icons.pets),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Next'),
              onPressed: () async {
                final returnval = await Navigator.pushNamed(
                  context,
                  '/two',
                  arguments: is_cat,
                );
                if (returnval != null) {
                  setState(() {
                    is_cat = false;
                  });
                }
              },
            ),
            IconButton(
              icon: Image.asset('assets/pic/1.jpg'),
              iconSize: 200,
              onPressed: () {
                print('is_cat: $is_cat');
              },
            ),
          ],
        ),
      ),
    );
  }
}
