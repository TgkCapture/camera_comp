import 'dart:io';

import 'package:camera_compare/viewmodels/image_comparison_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageComparisonView extends StatelessWidget {
  const ImageComparisonView({super.key});

  @override
  Widget build(BuildContext context) {
    var imageComparisonViewModel = Provider.of<ImageComparisonViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CameraComp'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imageComparisonViewModel.image1.imagePath)),
            ElevatedButton(
              onPressed: () => imageComparisonViewModel.pickImage(ImageSource.gallery, true),
              child: const Text('Pick Image 1'),
            ),
            const SizedBox(height: 20),
            Image.file(File(imageComparisonViewModel.image2.imagePath)),
            ElevatedButton(
              onPressed: () => imageComparisonViewModel.pickImage(ImageSource.gallery, false),
              child: const Text('Pick Image 2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: imageComparisonViewModel.compareImages,
              child: const Text('Compare Images'),
            ),
          ],
        ),
      ),
    );
  }
}
