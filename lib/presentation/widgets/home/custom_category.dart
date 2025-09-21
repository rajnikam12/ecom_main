import 'package:flutter/material.dart';

class CategoryScroll extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<String>? onCategorySelected;
  final bool isTablet;

  const CategoryScroll({
    super.key,
    required this.categories,
    this.onCategorySelected,
    this.isTablet = false,
  });

  @override
  State<CategoryScroll> createState() => _CategoryScrollState();
}

class _CategoryScrollState extends State<CategoryScroll> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing
    final chipHeight = widget.isTablet ? 50.0 : 40.0;
    final fontSize = widget.isTablet ? 16.0 : 14.0;
    final horizontalPadding = widget.isTablet ? 20.0 : 16.0;
    final verticalPadding = widget.isTablet ? 12.0 : 10.0;
    final spacing = widget.isTablet ? 16.0 : 12.0;
    final borderRadius = widget.isTablet ? 25.0 : 20.0;

    return SizedBox(
      height:
          chipHeight + (widget.isTablet ? 20 : 16), // Extra space for shadows
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: widget.isTablet ? 4 : 2,
          vertical: widget.isTablet ? 10 : 8,
        ),
        itemCount: widget.categories.length,
        separatorBuilder: (context, index) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = index == selectedIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                if (widget.onCategorySelected != null) {
                  widget.onCategorySelected!(category);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: widget.isTablet ? 12 : 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                            blurRadius: widget.isTablet ? 8 : 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontSize: fontSize,
                    ),
                    child: Text(
                      _formatCategoryName(category),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatCategoryName(String category) {
    if (category == "All") return category;

    // Capitalize first letter of each word
    return category.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
