import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatefulWidget {
  final String path;
  final String title;
  final String cover;

  PDFViewerScreen({
    required this.path,
    required this.title,
    required this.cover,
  });

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late PdfViewerController _pdfViewerController;
  int _lastPage = 0;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _loadLastPage();
    _saveLastRead(widget.title, widget.path, widget.cover);
  }

  Future<void> _saveLastRead(String title, String path, String cover) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_read_title', title);
    await prefs.setString('last_read_path', path);
    await prefs.setString('last_read_cover', cover);
  }

  Future<void> _saveLastPage(int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.title}_last_page', pageNumber);
  }

  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    final page = prefs.getInt('${widget.title}_last_page') ?? 1;
    _lastPage = page;

    // Tunggu sampai PDF selesai dibuka sebelum melompat ke halaman
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pdfViewerController.jumpToPage(_lastPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: widget.path.startsWith('http')
          ? SfPdfViewer.network(
              widget.path,
              controller: _pdfViewerController,
              onPageChanged: (details) {
                _saveLastPage(details.newPageNumber);
              },
            )
          : SfPdfViewer.file(
              File(widget.path),
              controller: _pdfViewerController,
              onPageChanged: (details) {
                _saveLastPage(details.newPageNumber);
              },
            ),
    );
  }
}
