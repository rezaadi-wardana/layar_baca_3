import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class Book {
  final int id;
  final String title;
  final String category;
  final String pdfUrl;
  final String cover;

  const Book({required this.id, required this.title, required this.category, required this.pdfUrl, required this.cover});

  factory Book.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'title': String title, 'category' : String category, 'pdfUrl' : String pdfUrl, 'cover': String cover} => Book(
        id: id,
        title: title,
        category: category,
        pdfUrl: pdfUrl,
        cover: cover,
      ),
      _ => throw const FormatException('Failed to load album.'),
    };
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
