import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 800,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Camera error: ${e.toString()}');
    }
  }

  Future<File?> chooseFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Gallery error: ${e.toString()}');
    }
  }
}