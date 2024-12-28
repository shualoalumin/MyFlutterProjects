import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// Entry point of the application
void main() => runApp(MyApp());

// Main application widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

// State for MyApp, manages theme mode
class MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // Tracks if dark mode is enabled

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, // Set theme mode
      theme: ThemeData.light(), // Light theme data
      darkTheme: ThemeData.dark(), // Dark theme data
      home: ImageUploadScreen(
        onToggleDarkMode: () {
          setState(() {
            _isDarkMode = !_isDarkMode; // Toggle dark mode
          });
        },
      ),
    );
  }
}

// Screen for image upload and classification
class ImageUploadScreen extends StatefulWidget {
  final VoidCallback onToggleDarkMode; // Callback to toggle dark mode

  const ImageUploadScreen({super.key, required this.onToggleDarkMode});

  @override
  ImageUploadScreenState createState() => ImageUploadScreenState();
}

// State for ImageUploadScreen, handles image selection and classification
class ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image; // Selected image file
  String? _imageUrl; // Image URL
  String _result = ""; // Classification result

  final picker = ImagePicker(); // Image picker instance
  final TextEditingController _urlController = TextEditingController(); // Controller for URL input

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageUrl = null; // Reset URL when a file is picked
      });
    }
  }

  // Function to classify the selected image or image from URL
  Future<void> _classifyImage() async {
    if (_image == null && _imageUrl == null) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://fef1-121-150-54-218.ngrok-free.app/"),
    );

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('file', _image!.path));
    } else if (_imageUrl != null) {
      request.fields['url'] = _imageUrl!;
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var decodedData = jsonDecode(responseData);
      setState(() {
        _result = decodedData['predictions'].toString(); // Update result with predictions
      });
    } else {
      setState(() {
        _result = "Error: ${response.statusCode}"; // Update result with error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Image Classifier"), // App bar title
        actions: [
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              widget.onToggleDarkMode(); // Toggle dark mode
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Image.file(_image!) // Display selected image
            else if (_imageUrl != null)
              Image.network(_imageUrl!), // Display image from URL
            ElevatedButton(
              onPressed: _pickImage, // Button to pick image
              child: SizedBox(
                width: 400,
                height: 65,
                child: Center(
                  child: Text(
                    "Upload Image",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _urlController, // Text field for URL input
                    decoration: InputDecoration(
                      labelText: "Enter Image URL",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _imageUrl = value;
                        _image = null; // Reset image when URL is submitted
                      });
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _classifyImage, // Button to classify image
              child: SizedBox(
                width: 400,
                height: 65,
                child: Center(
                  child: Text(
                    "Classify",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Text(_result), // Display classification result
          ],
        ),
      ),
    );
  }
}
