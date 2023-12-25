import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FaceComparisonService {
  final Dio _dio = Dio();

  // Replace these values with your Face++ API key and secret
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get apiSecret => dotenv.env['API_SECRET'] ?? '';
  static const String apiEndpoint = 'https://api-us.faceplusplus.com/facepp/v3/compare';

  Future<bool> compareImages(File image1, File image2) async {
    try {
      final response = await _dio.post(
        apiEndpoint,
        queryParameters: {
          'api_key': apiKey,
          'api_secret': apiSecret,
        },
        data: {
          'image_file1': await MultipartFile.fromFile(image1.path),
          'image_file2': await MultipartFile.fromFile(image2.path),
        },
      );

      final double confidence = response.data['confidence'];
      final bool isMatch = confidence > 70.0;

      return isMatch;
    } catch (error) {
      if (kDebugMode) {
        print('Error in face comparison: $error');
      }
      return false;
    }
  }
}
