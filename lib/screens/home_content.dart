// file: home_content.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/books_section.dart';
import '../screens/pdf_viewer.dart';
import '../models/books.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? lastReadTitle;
  String? lastReadPath;
  String? lastReadCover;

  late Future<List<Book>> _books;

  @override
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
    final loc = AppLocalizations.of(context)!;
    final user = Supabase.instance.client.auth.currentUser;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 32,
              ),
              const SizedBox(width: 10),
              Text(loc.appTitle, style: const TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 20),

          if (user != null) ...[
            Text(
              loc.lastOpened,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (lastReadTitle != null && lastReadPath != null && lastReadCover != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PDFViewerScreen(
                            path: lastReadPath!,
                            title: lastReadTitle!,
                            cover: lastReadCover!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
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
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(height: 180, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lastReadTitle!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(child: Text(loc.noBookRead)),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/literacy_banner.png',
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
          ],

          FutureBuilder<List<Book>>(
            future: _books,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('${loc.failedToLoad} ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text(loc.noBooks);
              }

              final books = snapshot.data!;
              final sortedBooks = List<Book>.from(books);
              sortedBooks.sort((a, b) => b.id.compareTo(a.id));
              final top5 = sortedBooks.take(5).toList();
              final allOtherBooks = sortedBooks.skip(5).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Buku Terbaru", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: top5.length,
                      itemBuilder: (context, index) {
                        final book = top5[index];
                        return FutureBuilder<bool>(
                          future: isFavorite(book.id),
                          builder: (context, favSnapshot) {
                            final isFav = favSnapshot.data ?? false;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SizedBox(
                                width: 140,
                                child: _buildBookCard(book, isFav),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text("Semua Buku", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: allOtherBooks.length,
                    itemBuilder: (context, index) {
                      final book = allOtherBooks[index];
                      return FutureBuilder<bool>(
                        future: isFavorite(book.id),
                        builder: (context, favSnapshot) {
                          final isFav = favSnapshot.data ?? false;
                          return _buildBookCard(book, isFav);
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book, bool isFav) {
    final user = Supabase.instance.client.auth.currentUser;
    return GestureDetector(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.cover,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 180, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (user != null)
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () => toggleFavorite(book.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
