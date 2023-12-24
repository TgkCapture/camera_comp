import 'dart:io';
// ignore: unused_import
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unused_import
import 'package:opencv_3/opencv_3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CameraComp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 38, 190, 183)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CameraComp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? imageOne;
  File? imageTwo;
  
  // ignore: non_constant_identifier_names
  get ImgProcCascadeClassifier => null;

  Future<void> _getImage(ImageSource source, {bool isCamera = false}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (imageOne == null) {
          imageOne = File(pickedFile.path);
        } else {
          imageTwo = File(pickedFile.path);
          _compareImages();
        }
      });
    }
  }

  Future<void> _compareImages() async {
    if (imageOne != null && imageTwo != null) {
      await _performFaceRecognition();
      _showResultDialog('Comparison completed.');
    }
  }

  Future<void> _performFaceRecognition() async {
  if (imageOne == null || imageTwo == null) {
    if (kDebugMode) {
      print('Error: Images not selected.');
    }
    return;
  }

  final firstImagePath = imageOne!.path;
  final secondImagePath = imageTwo!.path;

  try {
    // ignore: prefer_typing_uninitialized_variables
    var cascadeClassifier;
    final faceCascade = await ImgProcCascadeClassifier.load(cascadeClassifier.haarcascades + 'haarcascade_frontalface_default.xml');

    final firstImageMat = await ImgProc.imread(firstImagePath);
    final secondImageMat = await ImgProc.imread(secondImagePath);

    await ImgProc.cvtColor(firstImageMat, firstImageMat, ImgProc.colorBGR2GRAY);
    await ImgProc.cvtColor(secondImageMat, secondImageMat, ImgProc.colorBGR2GRAY);

    final firstFaces = await faceCascade.detectMultiScale(firstImageMat);
    final secondFaces = await faceCascade.detectMultiScale(secondImageMat);

    final isMatch = firstFaces.isNotEmpty && secondFaces.isNotEmpty;

    _showResultDialog(isMatch ? 'Success: Faces match!' : 'No match: Faces are different.');
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }
    _showResultDialog('Error: Face recognition failed.');
  }
  return;
}


  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Face Recognition Result'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CameraComp'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageOne != null)
              Image.file(
                imageOne!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: const Text('Select First Image'),
            ),
            const SizedBox(height: 20),
            if (imageOne != null)
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.camera, isCamera: true),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Front Camera Image'),
              ),
            if (imageOne != null)
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.camera, isCamera: false),
                icon: const Icon(Icons.camera_rear),
                label: const Text('Take Rear Camera Image'),
              ),
            const SizedBox(height: 20),
            if (imageTwo != null)
              Image.file(
                imageTwo!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}

class ImgProc {
  static var colorBGR2GRAY;

  static imread(String firstImagePath) {}
  
  static cvtColor(firstImageMat, firstImageMat2, colorBGR2GRAY) {}
}
