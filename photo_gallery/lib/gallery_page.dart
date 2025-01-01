import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'photo.dart';
import 'photo_saver.dart';
import 'photo_detail_page.dart';
import 'camera_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<Photo> _photos = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? photoPaths = prefs.getStringList('photo_paths');
      if (photoPaths != null) {
        setState(() {
          _photos = photoPaths
              .asMap()
              .entries
              .map((entry) => Photo(
                    id: entry.key,
                    url: entry.value,
                    title: 'Photo ${entry.key + 1}',
                  ))
              .toList();
        });
        print("Photo paths loaded in gallery: $photoPaths");
      }
    } catch (e) {
      print("Error loading photos: $e");
    }
  }

  void addPhoto(Uint8List imageBytes) async {
    final savedPath = await PhotoSaver.saveImage(imageBytes);
    if (savedPath != null) {
      setState(() {
        _photos.add(
          Photo(
            id: _photos.length,
            url: savedPath,
            title: 'New Photo ${_photos.length}',
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
      body: _photos.isEmpty
          ? Center(child: Text('No photos yet'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                final photo = _photos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailPage(photo: photo),
                      ),
                    );
                  },
                  child: Image.file(
                    File(photo.url),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Error loading image'));
                    },
                  ),
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
