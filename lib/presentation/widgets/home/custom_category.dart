import 'package:flutter/material.dart';

// Displays scrollable category chips
class CategoryScroll extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<String>? onCategorySelected;

  const CategoryScroll({
    super.key,
    required this.categories,
    this.onCategorySelected,
  });

  @override
  State<CategoryScroll> createState() => _CategoryScrollState();
}

class _CategoryScrollState extends State<CategoryScroll> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.categories.asMap().entries.map((entry) {
            int index = entry.key;
            String category = entry.value;
            bool isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                if (widget.onCategorySelected != null) {
                  widget.onCategorySelected!(category);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}