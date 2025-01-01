import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'last_photo_view_page.dart';

class CameraPage extends StatefulWidget {
  final Function(Uint8List) onPictureTaken;
  const CameraPage({super.key, required this.onPictureTaken});
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;
  bool isFlashVisible = false;
  File? lastPhoto;
  int selectedCameraIndex = 0;
  List<String> _photoPaths = [];

  @override
  void initState() {
    super.initState();
    initializeCamera();
    _loadPhotoPaths();
  }

  Future<void> _loadPhotoPaths() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? savedPaths = prefs.getStringList('photo_paths');
      if (savedPaths != null) {
        _photoPaths = savedPaths;
        if (_photoPaths.isNotEmpty) {
          setState(() {
            lastPhoto = File(_photoPaths.last);
          });
        }
      }
    } catch (e) {
      print("Error loading photo paths: $e");
    }
  }

  Future<void> _savePhotoPaths() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('photo_paths', _photoPaths);
      print("Photo paths saved: $_photoPaths");
    } catch (e) {
      print("Error saving photo paths: $e");
    }
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[selectedCameraIndex],
          ResolutionPreset.high,
        );
        await _cameraController.initialize();
        setState(() {
          isCameraInitialized = true;
        });
      } else {
        print("No cameras available");
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  void switchCamera() {
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    if (!isCameraInitialized) {
      print("Camera is not initialized");
      return;
    }

    try {
      setState(() {
        isFlashVisible = true;
      });

      await Future.delayed(Duration(microseconds: 1));

      final image = await _cameraController.takePicture();
      final imageBytes = await File(image.path).readAsBytes();

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'photo_${DateTime.now()}.jpg';
      final filePath = path.join(directory.path, fileName);
      final File newImage = await File(image.path).copy(filePath);

      setState(() {
        lastPhoto = newImage;
        _photoPaths.add(newImage.path);
        print("Photo taken, path added: ${newImage.path}");
      });
      await _savePhotoPaths();
      setState(() {
        isFlashVisible = false;
      });

      widget.onPictureTaken(imageBytes);
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  void _viewLastPhoto(BuildContext context) {
    if (lastPhoto != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LastPhotoViewPage(
            photoFile: lastPhoto!,
            onRetake: () {
              Navigator.pop(context); // Close the last photo view
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Camera"),
          centerTitle: true,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: AspectRatio(
                    aspectRatio: _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                  ),
                ),
              ),
              if (isFlashVisible)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withAlpha(128),
                  ),
                ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => _viewLastPhoto(context),
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: lastPhoto != null
                                ? DecorationImage(
                                    image: FileImage(lastPhoto!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: takePicture,
                        child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: switchCamera,
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.flip_camera_android,
                              color: const Color.fromRGBO(83, 61, 61, 1),
                              size: 30.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
