import 'package:flutter/material.dart';
import 'package:pawfect_care/models/article.dart';
import 'package:pawfect_care/theme/theme.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article article;
  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.coverImageUrl.isNotEmpty)
              Image.network(
                article.coverImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: PawfectCareTheme.chipBackground,
                  height: 200,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: PawfectCareTheme.primaryBlue.withOpacity(0.5),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: PawfectCareTheme.headingMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.subtitle,
              style: PawfectCareTheme.bodyLarge.copyWith(
                fontStyle: FontStyle.italic,
                color: PawfectCareTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'By ${article.authorId} (${article.authorRole}) - ${article.createdAt.toLocal().toShortDateString()}',
              style: PawfectCareTheme.caption.copyWith(
                color: PawfectCareTheme.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article.articleContent,
              style: PawfectCareTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

extension on DateTime {
  String toShortDateString() {
    return '${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}
