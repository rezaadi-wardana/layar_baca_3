import 'package:flutter/material.dart';

class BookItem extends StatelessWidget{
  final String imagePath;

  BookItem({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        image: DecorationImage(image: AssetImage(imagePath),
        fit: BoxFit.cover,
        ),
      ),
    );
  }
}
