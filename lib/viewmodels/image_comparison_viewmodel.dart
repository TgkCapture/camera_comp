import 'dart:io';

import 'package:camera_compare/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/image_model.dart';
import '../services/face_comparison_service.dart';

class ImageComparisonViewModel with ChangeNotifier {
  final FaceComparisonService _faceComparisonService = FaceComparisonService();
  late ImageModel _image1;
  late ImageModel _image2;

  ImageModel get image1 => _image1;
  ImageModel get image2 => _image2;

  Future<void> pickImage(ImageSource source, bool isFirstImage) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final imageName = path.basename(imageFile.path);
      final appDir = await getApplicationDocumentsDirectory();
      final savedImage = await imageFile.copy('${appDir.path}/$imageName');

      if (isFirstImage) {
        _image1 = ImageModel(savedImage.path);
      } else {
        _image2 = ImageModel(savedImage.path);
      }

      notifyListeners();
    }
  }

  Future<void> compareImages() async {
    final result = await _faceComparisonService.compareImages(
      File(_image1.imagePath),
      File(_image2.imagePath),
    );

    if (result) {
      _showResultDialog('Match', 'The images match!');
    } else {
      _showResultDialog('No Match', 'The images do not match.');
    }
    }

  void _showResultDialog(String title, String message) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
