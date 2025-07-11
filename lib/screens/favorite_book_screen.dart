// file: favorite_books_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteBooksScreen extends StatefulWidget {
  const FavoriteBooksScreen({super.key});

  @override
  State<FavoriteBooksScreen> createState() => _FavoriteBooksScreenState();
}

class _FavoriteBooksScreenState extends State<FavoriteBooksScreen> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchFavoriteBooks() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final favorites = await supabase
        .from('favorites')
        .select('book_id')
        .eq('user_id', user.id);

    final bookIds = favorites.map((f) => f['book_id']).toList();

    if (bookIds.isEmpty) return [];

    final books = await supabase
        .from('books')
        .select()
        .inFilter('id', bookIds);

    return List<Map<String, dynamic>>.from(books);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.favoriteBooks)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFavoriteBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: const Text("No favorite"));
          }

          final favoriteBooks = snapshot.data!;
          return ListView.builder(
            itemCount: favoriteBooks.length,
            itemBuilder: (context, index) {
              final book = favoriteBooks[index];
              return ListTile(
                leading: Image.network(
                  book['cover'],
                  width: 40,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(book['title']),
                subtitle: Text(book['category']),
              );
            },
          );
        },
      ),
    );
  }
}
