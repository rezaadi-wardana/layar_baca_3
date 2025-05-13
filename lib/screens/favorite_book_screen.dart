import 'package:flutter/material.dart';

class FavoriteBooksScreen extends StatelessWidget {
  const FavoriteBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulasi list buku favorit
    final favoriteBooks = [
      {'title': 'Bumi', 'author': 'Tere Liye'},
      {'title': 'Laskar Pelangi', 'author': 'Andrea Hirata'},
      {'title': 'Negeri 5 Menara', 'author': 'Ahmad Fuadi'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buku Favorit"),
      ),
      body: ListView.builder(
        itemCount: favoriteBooks.length,
        itemBuilder: (context, index) {
          final book = favoriteBooks[index];
          return ListTile(
            leading: const Icon(Icons.star, color: Colors.red),
            title: Text(book['title']!),
            subtitle: Text(book['author']!),
          );
        },
      ),
    );
  }
}
