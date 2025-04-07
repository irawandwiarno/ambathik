import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Ambil gambar dari galeri
  static Future<XFile?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      print("❌ Failed to pick image from gallery: $e");
      return null;
    }
  }

  /// Ambil gambar dari kamera
  static Future<XFile?> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      return image;
    } catch (e) {
      print("❌ Failed to pick image from camera: $e");
      return null;
    }
  }
}
