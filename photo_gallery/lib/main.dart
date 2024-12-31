import 'package:flutter/material.dart';
import 'gallery_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery',
      theme: ThemeData.dark(),
      home: GalleryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
