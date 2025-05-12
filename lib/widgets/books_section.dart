import 'package:flutter/material.dart';
import 'book_item.dart';

class BookSection extends StatelessWidget {
  final String title;
  final List<String> books;

  BookSection({ required this.title, required this.books});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600 ),),
        SizedBox(height: 10),
        SizedBox(
          height: 180,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (ctx, index) => BookItem(imagePath: books[index]),),
        ),
        SizedBox(height: 20,),
      ],
    );
  }
}