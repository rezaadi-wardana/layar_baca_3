// file: home_content.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/books_section.dart';
import '../screens/pdf_viewer.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? lastReadTitle;
  String? lastReadPath;

  final keepReading = [
    'assets/images/Bisnis_Ala_Nabi.png',
    'assets/images/Start_With_Why.png',
    'assets/images/The_Decision_Book.png',
  ];

  final waitingForYou = [
    'assets/images/cover1.png',
    'assets/images/cover2.png',
    'assets/images/cover3.png',
  ];

  @override
  void initState() {
    super.initState();
    loadLastRead();
  }

  Future<void> loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastReadTitle = prefs.getString('last_read_title');
      lastReadPath = prefs.getString('last_read_path');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          Center(child: Text('Layar Baca 3', style: TextStyle(fontSize: 24))),
          SizedBox(height: 20),
          Text("Opened Lastly", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          if (lastReadTitle != null && lastReadPath != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PDFViewerScreen(
                      path: lastReadPath!,
                      title: lastReadTitle!,
                    ),
                  ),
                );
              },
              child: Container(
                width: 120,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    lastReadTitle!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )
          else
            Text("Belum ada buku yang dibaca."),
          SizedBox(height: 20),
          BookSection(title: "Keep reading", books: keepReading),
          BookSection(title: "Waiting for you", books: waitingForYou),
        ],
      ),
    );
  }
}

