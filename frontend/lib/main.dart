import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ImageUploader(),
    );
  }
}

class ImageUploader extends StatefulWidget {
  const ImageUploader({super.key});

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _image;
  String _result = "";
  double _score = 0.0000;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      setState(() {
        _result = "No image selected.";
      });
      return;
    }

    print("Uploading image...");
    final url = 'https://24e4-121-150-54-218.ngrok-free.app/upload/';
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);
        setState(() {
          _result = decodedData['result']['predicted_label'] ?? "Unknown";
          _score = double.tryParse(decodedData['result']['prediction_score']) ?? 0.0;
        });
        print("Upload successful: $decodedData");
      } else {
        setState(() {
          _result = "Error: Unable to upload image.";
        });
        print("Upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _result = "Error: ${e.toString()}";
      });
      print("Exception occurred: ${e.toString()}");
    }
  }

  void _reset() {
    setState(() {
      _image = null;
      _result = "";
      _score = 0.0000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Jellyfish Classifier'),
        leading: Icon(Icons.ac_unit),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text("No image selected.")
                : Image.file(_image!, height: 300, width: 300),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.play_arrow, color: Colors.yellow),
                      onPressed: _uploadImage,
                    ),
                    Text('예측결과'),
                    Text(_result),
                  ],
                ),
                Column(
                  children: [
                    Text('예측확률'),
                    Text(_score.toStringAsFixed(4)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reset,
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
