import 'package:flutter/material.dart';
import 'package:pawfect_care/providers/pet_store_provider.dart';

class CategorySelector extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = category == widget.selectedCategory;

          return Container(
            margin: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => widget.onCategorySelected(category),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6B9AC4)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6B9AC4)
                        : Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      fontSize: 16.0,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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

}
