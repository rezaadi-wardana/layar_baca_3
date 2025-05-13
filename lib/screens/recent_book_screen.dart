import 'package:flutter/material.dart';

class RecentBooksScreen extends StatelessWidget {
  const RecentBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulasi list buku terakhir dibaca
    final recentBooks = [
      {'title': 'Ayah', 'author': 'Andrea Hirata'},
      {'title': 'Pulang', 'author': 'Tere Liye'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Terakhir Dibaca"),
      ),
      body: ListView.builder(
        itemCount: recentBooks.length,
        itemBuilder: (context, index) {
          final book = recentBooks[index];
          return ListTile(
            leading: const Icon(Icons.history, color: Colors.grey),
            title: Text(book['title']!),
            subtitle: Text(book['author']!),
          );
        },
      ),
    );
  }
}
