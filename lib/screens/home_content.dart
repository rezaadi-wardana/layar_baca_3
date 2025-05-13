// file: home_content.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/books_section.dart';
import '../screens/pdf_viewer.dart';
import '../models/books.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? lastReadTitle;
  String? lastReadPath;
  String? lastReadCover;

  @override
  late Future<List<Book>> _books;

  void initState() {
    super.initState();
    loadLastRead();
    _books = fetchBooks();
  }

  Future<void> loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastReadTitle = prefs.getString('last_read_title');
      lastReadPath = prefs.getString('last_read_path');
      lastReadCover = prefs.getString('last_read_cover');
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
          Text(
            "Terakhir Dibuka",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (lastReadTitle != null &&
              lastReadPath != null &&
              lastReadCover != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => PDFViewerScreen(
                          path: lastReadPath!,
                          title: lastReadTitle!,
                          cover: lastReadCover!,
                        ),
                  ),
                );
              },
              child: Container(
                  margin: EdgeInsets.only(right: 12),
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        lastReadCover!.trim(),
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Container(height: 180, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      lastReadTitle!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          // GestureDetector(
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) => PDFViewerScreen(
          //               path:lastReadPath!,
          //               title:lastReadTitle!,
          //             ),
          //           ),
          //         );
          //       },
          //       child: Container(
          //         margin: EdgeInsets.only(right: 12),
          //         width: 120,
          //         child: Column(
          //           children: [
          //             Expanded(
          //               child: ClipRRect(
          //                 borderRadius: BorderRadius.circular(8),
          //                 child: Image.network(
          //                   lastReadCover!.trim(),
          //                   fit: BoxFit.cover,
          //                   errorBuilder: (context, error, stackTrace) =>
          //                       Container(color: Colors.grey),
          //                 ),
          //               ),
          //             ),
          //             SizedBox(height: 4),
          //             Text(
          //               lastReadTitle!,
          //               textAlign: TextAlign.center,
          //               maxLines: 2,
          //               overflow: TextOverflow.ellipsis,
          //               style: TextStyle(fontSize: 12),
          //             ),
          //           ],
          //         ),
          //       ),
          //     )
          else
            Text("Belum ada buku yang dibaca."),
          SizedBox(height: 20),
          FutureBuilder<List<Book>>(
            future: _books,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Gagal memuat data: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Tidak ada buku tersedia.');
              }

              final books = snapshot.data!;
              return Column(
                children: [
                  BookSection(title: "Populer", books: books),
                  SizedBox(height: 20),
                  BookSection(
                    title: "Rekomendasi",
                    books: books.reversed.toList(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Future<List<Book>>>('_books', _books));
  }
}
