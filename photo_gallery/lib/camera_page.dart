import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'photo_detail_page.dart';
import 'photo.dart';

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

  @override
  void initState() {
    super.initState();
    initializeCamera();
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
      await Future.delayed(Duration(milliseconds: 1));
      final image = await _cameraController.takePicture();
      final imageBytes = await File(image.path).readAsBytes();
      setState(() {
        lastPhoto = File(image.path);
        isFlashVisible = false;
      });
      widget.onPictureTaken(imageBytes);
    } catch (e) {
      print("Error taking picture: $e");
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
                        onTap: () {
                          if (lastPhoto != null) {
                            final photo = Photo(
                              id: 0,
                              url: lastPhoto!.path,
                              title: 'Last Photo',
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PhotoDetailPage(photo: photo),
                              ),
                            );
                          }
                        },
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
                          child: Icon(Icons.cameraswitch, color: Colors.black, size: 24.0),
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