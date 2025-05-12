import 'package:supabase_flutter/supabase_flutter.dart';

class Book {
  final String title;
  final String category;
  final String cover;
  final String pdfUrl;

  Book({required this.title, required this.category, required this.cover, required this.pdfUrl});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      category: json['category'],
      cover: json['cover'],
      pdfUrl: json['pdfUrl'],
    );
  }
}

Future<List<Book>> fetchBooks() async {
  final response = await Supabase.instance.client
      .from('books')
      .select();

  return (response as List)
      .map((json) => Book.fromJson(json))
      .toList();
}
