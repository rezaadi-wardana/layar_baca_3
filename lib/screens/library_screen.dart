import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/category_filter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'pdf_viewer.dart';
import '../models/books.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Book>> _books;
  String selectedCategory = 'All';
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _books = fetchBooks();
  }

  Future<void> toggleFavorite(int bookId) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final existing = await supabase
        .from('favorites')
        .select()
        .eq('user_id', user.id)
        .eq('book_id', bookId);

    if (existing.isEmpty) {
      await supabase.from('favorites').insert({
        'user_id': user.id,
        'book_id': bookId,
      });
    } else {
      await supabase
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('book_id', bookId);
    }

    setState(() {});
  }

  Future<bool> isFavorite(int bookId) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    final data = await supabase
        .from('favorites')
        .select()
        .eq('user_id', user.id)
        .eq('book_id', bookId);

    return data.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Library')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) => setState(() => searchText = value),
              decoration: InputDecoration(
                hintText: 'Search books...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          CategoryFilter(
            categories: ['All', 'Bisnis', 'Islami', 'Hukum', 'Teknologi', 'Novel'],
            selected: selectedCategory,
            onSelected: (cat) => setState(() => selectedCategory = cat),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _books,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No books available.'));
                } else {
                  final books = snapshot.data!;
                  final filteredBooks = books.where((book) {
                    final matchCategory = selectedCategory == 'All' || book.category == selectedCategory;
                    final matchSearch = book.title.toLowerCase().contains(searchText.toLowerCase());
                    return matchCategory && matchSearch;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (ctx, i) {
                      final book = filteredBooks[i];
                      return FutureBuilder<bool>(
                        future: isFavorite(book.id),
                        builder: (context, favSnapshot) {
                          final isFav = favSnapshot.data ?? false;
                          return ListTile(
                            leading: Image.network(book.cover),
                            title: Text(book.title),
                            subtitle: Text(book.category),
                            trailing: user != null
                                ? IconButton(
                                    icon: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => toggleFavorite(book.id),
                                  )
                                : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PDFViewerScreen(
                                    path: book.pdfUrl,
                                    title: book.title,
                                    cover: book.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
