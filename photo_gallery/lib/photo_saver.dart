import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class PhotoSaver {
  static Future<String?> saveImage(Uint8List imageBytes) async {
    try {
      // 앱의 로컬 디렉토리 경로 가져오기
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/saved_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 파일 저장
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      return filePath; // 저장된 파일 경로 반환
    } catch (e) {
      print("Error saving image: $e");
      return null;
    }
  }
}
