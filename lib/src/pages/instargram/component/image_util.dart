import 'package:image/image.dart' as img;
import 'dart:typed_data';

class ImageUtil {
  /// 이미지를 압축하여 Uint8List로 반환
  static Future<Uint8List?> compressImageData(Uint8List imageData, {int quality = 100}) async {
    try {
      // 이미지를 디코딩
      final img.Image? decodedImage = img.decodeImage(imageData);
      if (decodedImage == null) {
        print('이미지 디코딩 실패');
        return null;
      }

      // 압축된 이미지 데이터를 JPEG 형식으로 변환
      final Uint8List compressedImage = Uint8List.fromList(
        img.encodeJpg(decodedImage, quality: quality),
      );

      return compressedImage;
    } catch (e) {
      print('이미지 압축 중 오류 발생: $e');
      return null;
    }
  }
}
