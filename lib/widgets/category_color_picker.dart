import 'package:flutter/material.dart';

class CategoryColorPicker extends StatelessWidget {
  final String selectedCategory;
  final Color selectedColor;
  final Function(String, Color) onCategoryChanged;

  CategoryColorPicker({super.key, 
    required this.selectedCategory,
    required this.selectedColor,
    required this.onCategoryChanged,
  });

  final Map<String, Color> _categories = {
    'General': Colors.purple,
    'TV': Colors.blue,
    'Finance': Colors.green,
    'Games': Colors.red,
    'Programming': Colors.orange,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category'),
        DropdownButton<String>(
          value: selectedCategory,
          items: _categories.keys
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _categories[category],
                          radius: 10,
                        ),
                        SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            onCategoryChanged(value!, _categories[value]!);
          },
        ),
      ],
    );
  }
}
