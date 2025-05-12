import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFViewerScreen extends StatelessWidget {
  final String path;
  final String title;

  PDFViewerScreen({required this.path, required this.title});

  Future<void> saveLastRead(String title, String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_read_title', title);
    await prefs.setString('last_read_path', path);
  }

  @override
  Widget build(BuildContext context) {
    saveLastRead(title, path);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PDFView(
        filePath: path,
      ),
    );
  }
}
