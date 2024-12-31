import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'photo.dart';
import 'photo_saver.dart';
import 'photo_detail_page.dart';
import 'camera_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<Photo> photos = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    // 로컬 디렉토리에서 사진 데이터를 불러옵니다.
  }

  void addPhoto(Uint8List imageBytes) async {
    final savedPath = await PhotoSaver.saveImage(imageBytes);
    if (savedPath != null) {
      setState(() {
        photos.add(
          Photo(
            id: photos.length,
            url: savedPath,
            title: 'New Photo ${photos.length}',
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Josh Gallery"),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetailPage(photo: photo),
                ),
              );
            },
            child: Image.file(File(photo.url), fit: BoxFit.cover),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // CameraPage를 사용하여 사진을 추가하는 로직
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraPage(onPictureTaken: addPhoto),
            ),
          );
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
