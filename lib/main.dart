import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? imageOne;
  File? imageTwo;

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (imageOne == null) {
          imageOne = File(pickedFile.path);
        } else {
          imageTwo = File(pickedFile.path);
          _compareimages();
        }
      });
    }
  }
  
  Future<bool> _compareimages() async {
    final imageOneinfo = await imageOne?.readAsBytes();
    final imageTwoinfo = await imageTwo?.readAsBytes();

    final imageOneBytes = Uint8List.fromList(imageOneinfo as List<int>);
    final imageTwoBytes = Uint8List.fromList(imageTwoinfo as List<int>);

    final firstImage = img.decodeImage(imageOneBytes);
    final secondImage = img.decodeImage(imageTwoBytes);

    for (int y = 0; y < firstImage!.height; y++) {
      for (int x = 0; x < secondImage!.width; x++) {
        if (firstImage.getPixel(x, y) != secondImage.getPixel(x, y)) {
          _showResultDialog('No match: Images are different.');
          return false;
        }
      }
    }

    _showResultDialog('Success: Images match!');
    return true;
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image Comparison Result'),
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
              ElevatedButton(
                onPressed: () => _getImage(ImageSource.camera),
                child: const Text('Take Second Image'),
              ),
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
