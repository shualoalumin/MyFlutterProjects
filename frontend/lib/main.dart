// 필요한 라이브러리를 가져옵니다. 'dart:convert'는 JSON 변환을 위해, 'dart:io'는 파일 처리를 위해 사용됩니다.
import 'dart:convert';
import 'dart:io';

// Flutter와 관련된 패키지를 가져옵니다.
import 'package:flutter/material.dart';
// HTTP 요청을 위해 'http' 패키지를 가져옵니다.
import 'package:http/http.dart' as http;
// 이미지 선택을 위해 'image_picker' 패키지를 가져옵니다.
import 'package:image_picker/image_picker.dart';

// 앱의 진입점입니다. MyApp 위젯을 실행합니다.
void main() {
  runApp(MyApp());
}

// MyApp 클래스는 StatelessWidget을 상속받아 앱의 기본 구조를 정의합니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp 위젯을 반환하여 앱의 제목과 홈 화면을 설정합니다.
    return MaterialApp(
      theme: ThemeData.dark(), // 다크 모드 테마를 설정합니다.
      home: ImageUploader(), // ImageUploader 위젯을 홈 화면으로 설정합니다.
    );
  }
}

// ImageUploader 클래스는 StatefulWidget을 상속받아 상태를 관리합니다.
class ImageUploader extends StatefulWidget {
  const ImageUploader({super.key});

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

// _ImageUploaderState 클래스는 ImageUploader의 상태를 정의합니다.
class _ImageUploaderState extends State<ImageUploader> {
  // 선택된 이미지를 저장할 변수입니다.
  File? _image;
  // 결과 메시지를 저장할 변수입니다.
  String _result = "Upload an image to get predictions";

  // ImagePicker 인스턴스를 생성합니다.
  final ImagePicker _picker = ImagePicker();

  // 이미지를 선택하는 비동기 함수입니다.
  Future<void> _pickImage() async {
    // 갤러리에서 이미지를 선택합니다.
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // 선택된 이미지가 있으면 상태를 업데이트합니다.
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 이미지를 업로드하는 비동기 함수입니다.
  Future<void> _uploadImage() async {
    // 이미지가 선택되지 않았으면 메시지를 업데이트하고 함수를 종료합니다.
    if (_image == null) {
      setState(() {
        _result = "No image selected.";
      });
      return;
    }

    // 이미지 업로드를 시작합니다.
    print("Uploading image...");
    // 업로드할 URL을 설정합니다.
    final url = 'https://be8d-121-150-54-218.ngrok-free.app/upload/';
    // HTTP POST 요청을 생성합니다.
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // 선택된 이미지를 요청에 추가합니다.
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    try {
      // 요청을 전송하고 응답을 기다립니다.
      final response = await request.send();
      if (response.statusCode == 200) {
        // 응답이 성공적이면 데이터를 읽고 상태를 업데이트합니다.
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);
        setState(() {
          _result = decodedData['result']['predicted_label'];
        });
        print("Upload successful: $decodedData");
      } else {
        // 응답이 실패하면 오류 메시지를 업데이트합니다.
        setState(() {
          _result = "Error: Unable to upload image.";
        });
        print("Upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      // 예외가 발생하면 오류 메시지를 업데이트합니다.
      setState(() {
        _result = "Error: ${e.toString()}";
      });
      print("Exception occurred: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI를 구성하는 위젯을 반환합니다.
    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Classification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 이미지가 선택되지 않았으면 메시지를 표시하고, 선택되었으면 이미지를 표시합니다.
            _image == null
                ? Text("No image selected.")
                : Image.file(_image!, height: 200),
            SizedBox(height: 20),
            // 이미지를 선택할 수 있는 버튼입니다.
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            // 이미지를 업로드할 수 있는 버튼입니다.
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Classify Image'),
            ),
            SizedBox(height: 20),
            // 결과 메시지를 표시합니다.
            Text(
              _result,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
