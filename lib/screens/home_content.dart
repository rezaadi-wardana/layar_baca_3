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
    });
  }

  // final keepReading = [
  //   'assets/images/Bisnis_Ala_Nabi.png',
  //   'assets/images/Start_With_Why.png',
  //   'assets/images/The_Decision_Book.png',
  // ];

  // final waitingForYou = [
  //   'assets/images/cover1.png',
  //   'assets/images/cover2.png',
  //   'assets/images/cover3.png',
  // ];
  // @override
  // Widget build(BuildContext context) {
  //   FutureBuilder<List<Book>>(
  //     future: _books,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator();
  //       } else if (snapshot.hasError) {
  //         return Text('Gagal memuat data: ${snapshot.error}');
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         return Text('Tidak ada buku tersedia.');
  //       }

  //       final books = snapshot.data!;
  //       return Column(
  //         children: [
  //           BookSection(title: "Populer", books: books),
  //           SizedBox(height: 20),
  //           BookSection(title: "Rekomendasi", books: books.reversed.toList()),
  //         ],
  //       );
  //     },
  //   );


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
                BookSection(title: "Rekomendasi", books: books.reversed.toList()),
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

    // return Padding(
    //   padding: const EdgeInsets.all(12),
    //   child: ListView(
    //     children: [
    //       Center(child: Text('Layar Baca 3', style: TextStyle(fontSize: 24))),
    //       SizedBox(height: 20),
    //       Text(
    //         "Terakhir Dibuka",
    //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //       ),
    //       SizedBox(height: 8),
    //       if (lastReadTitle != null && lastReadPath != null)
    //         GestureDetector(
    //           onTap: () {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder:
    //                     (_) => PDFViewerScreen(
    //                       path: lastReadPath!,
    //                       title: lastReadTitle!,
    //                     ),
    //               ),
    //             );
    //           },
    //           child: Container(
    //             width: 120,
    //             height: 180,
    //             decoration: BoxDecoration(
    //               color: Colors.grey[300],
    //               borderRadius: BorderRadius.circular(8),
    //             ),
    //             child: Center(
    //               child: Text(
    //                 lastReadTitle!,
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(fontSize: 16),
    //               ),
    //             ),
    //           ),
    //         )
    //       else
    //         Text("Belum ada buku yang dibaca."),
    //       SizedBox(height: 20),
    //       BookSection(title: "Populer", books: keepReading),
    //       BookSection(title: "Rekomendasi", books: waitingForYou),
    //     ],
    //   ),
    // );
  }

