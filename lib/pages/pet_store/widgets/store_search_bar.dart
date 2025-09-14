
import 'package:flutter/material.dart';

class StoreSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String searchQuery;

  const StoreSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF263238),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search pet products...',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600],
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.grey[600],
            ),
            onPressed: () {
              controller.clear();
              onChanged('');
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}