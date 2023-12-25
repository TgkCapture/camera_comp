// main.dart
import 'package:camera_compare/viewmodels/image_comparison_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/image_comparison_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImageComparisonViewModel(),
      child: MaterialApp(
        title: 'CameraComp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ImageComparisonView(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
