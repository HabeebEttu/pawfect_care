// widgets/empty_state_widget.dart
import 'package:flutter/material.dart';


class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyState({
    super.key,
    this.icon = Icons.pets,
    this.title = 'No items found',
    this.message = 'Try adjusting your search or filters',
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (onActionPressed != null && actionLabel != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onActionPressed,
              child: Text(actionLabel!),
            ),
          ]
        ],
      ),
    );
  }
}
