import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget{
  final List<String> categories;
  final String selected;
  final Function(String) onSelected;

  CategoryFilter({required this.categories, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          final cat = categories[index];
          final isSelected = cat == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (_) => onSelected(cat),
              selectedColor: Colors.red,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(color: isSelected? Colors.white : Colors.black),
            ), );
        },
      ),
    );
  }
}