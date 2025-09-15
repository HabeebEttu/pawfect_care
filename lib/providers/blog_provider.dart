import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/models/article.dart';
import 'package:pawfect_care/services/blog_service.dart';

/// BlogService provider
final blogServiceProvider = Provider<BlogService>((ref) {
  return BlogService();
});

/// Articles state notifier provider
final articlesProvider = StateNotifierProvider<ArticlesNotifier, AsyncValue<List<Article>>>((ref) {
      final blogService = ref.watch(blogServiceProvider);
      return ArticlesNotifier(blogService);
    });

/// Categories provider (use Provider instead of FutureProvider since static)
final categoriesProvider = Provider<List<String>>((ref) {
  return [
    'All',
    'Pet Care',
    'Health Tips',
    'Training',
    'Nutrition',
    'Behavior',
    'General',
  ];
});

class ArticlesNotifier extends StateNotifier<AsyncValue<List<Article>>> {
  final BlogService _blogService;

  ArticlesNotifier(this._blogService) : super(const AsyncValue.loading()) {
    _fetchArticles();
  }

  /// Fetch all articles
  Future<void> _fetchArticles() async {
    state = await AsyncValue.guard(() async {
      return await _blogService.getAllArticles();
    });
  }

  /// Refresh manually (for pull-to-refresh in UI)
  Future<void> refreshArticles() async => _fetchArticles();

  /// Add new article with optimistic update
  Future<void> addArticle(Article article) async {
    final previous = state.value ?? [];

    // Optimistically add article to list
    state = AsyncValue.data([...previous, article]);

    try {
      await _blogService.addArticleToBlog(article);
      await _fetchArticles(); // Sync with backend
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update an article
  Future<void> updateArticle(Article article) async {
    state = await AsyncValue.guard(() async {
      await _blogService.updateArticle(article);
      return await _blogService.getAllArticles();
    });
  }

  /// Delete an article
  Future<void> deleteArticle(String id) async {
    state = await AsyncValue.guard(() async {
      await _blogService.deleteArticle(id);
      return await _blogService.getAllArticles();
    });
  }
}
