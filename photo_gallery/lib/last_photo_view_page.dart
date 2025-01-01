import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'gallery_page.dart';
import 'camera_page.dart';

class LastPhotoViewPage extends StatelessWidget {
  final File photoFile;
  final VoidCallback onRetake;

  const LastPhotoViewPage({
    super.key,
    required this.photoFile,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Photo'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              photoFile,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the last photo view
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GalleryPage()),
                        );
                      },
                      child: const Text('Go to Gallery'),
                    );
                  },
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the last photo view
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraPage(
                                onPictureTaken: (Uint8List imageBytes) {},
                              )),
                    );
                  },
                  child: const Text('Retake'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
