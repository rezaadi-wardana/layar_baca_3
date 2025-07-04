import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String path;
  final String title;
  final String cover;

  PDFViewerScreen({
    required this.path, 
    required this.title,
    required this.cover
    });

  Future<void> saveLastRead(String title, String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_read_title', title);
    await prefs.setString('last_read_path', path);
    await prefs.setString('last_read_cover', cover);
  }

  @override
  Widget build(BuildContext context) {
    saveLastRead(title, path);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: path.startsWith('http')
          ? SfPdfViewer.network(path)
          : SfPdfViewer.file(File(path)),
    );
  }
}
