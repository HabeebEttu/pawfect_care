import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/providers/blog_provider.dart';
import 'package:pawfect_care/models/article.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:pawfect_care/pages/article_detail_page.dart';

class BlogPage extends ConsumerStatefulWidget {
  const BlogPage({super.key});

  @override
  ConsumerState<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends ConsumerState<BlogPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isSearchExpanded = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<Article> _filterArticles(List<Article> articles) {
    return articles.where((article) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.articleContent.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

    //   final matchesCategory =
    //       _selectedCategory == 'All' ||
    //       (article.category?.toLowerCase() ?? 'general') ==
    //           _selectedCategory.toLowerCase();

      return matchesSearch;
    }).toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final articlesAsyncValue = ref.watch(articlesProvider);
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: PawfectCareTheme.backgroundWhite,
      appBar: _buildAppBar(),
      body: articlesAsyncValue.when(
        data: (allArticles) {
          final filteredArticles = _filterArticles(allArticles);
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(allArticles.length),
                _buildSearchAndFilter(),
                ref.watch(categoriesProvider).when(
                  data: (categories) => _buildCategoryChips(categories),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                ),
                Expanded(
                  child: filteredArticles.isEmpty
                      ? _buildEmptyState()
                      : _buildArticlesList(filteredArticles),
                ),
              ],
            ),
          );
        },
        loading: () => _buildLoadingState(),
        error: (e, st) => _buildErrorState(e.toString()),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: PawfectCareTheme.backgroundWhite,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Blogs & Tips",
        style: PawfectCareTheme.headingSmall.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSearchExpanded = !_isSearchExpanded;
            });
          },
          icon: Icon(
            _isSearchExpanded ? Icons.close : Icons.search,
            color: PawfectCareTheme.primaryBlue,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeader(int totalArticles) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PawfectCareTheme.primaryBlue.withValues(alpha: 0.1),
            PawfectCareTheme.accentBlue.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PawfectCareTheme.primaryBlue.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pet Care Knowledge Hub',
                  style: PawfectCareTheme.headingMedium.copyWith(
                    color: PawfectCareTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover expert tips, guides, and insights to keep your furry friends happy and healthy.',
                  style: PawfectCareTheme.bodyMedium.copyWith(
                    color: PawfectCareTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: PawfectCareTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: PawfectCareTheme.primaryBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '$totalArticles Articles Available',
                    style: PawfectCareTheme.bodySmall.copyWith(
                      color: PawfectCareTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: PawfectCareTheme.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.article,
              size: 32,
              color: PawfectCareTheme.primaryBlue.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isSearchExpanded ? 70 : 0,
      child: _isSearchExpanded
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search articles, tips, and guides...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: PawfectCareTheme.primaryBlue,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: PawfectCareTheme.dividerGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: PawfectCareTheme.primaryBlue,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildCategoryChips(List<String> categories) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;

          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedCategory = category;
              });
            },
            backgroundColor: Colors.white,
            selectedColor: PawfectCareTheme.primaryBlue.withValues(alpha: 0.1),
            checkmarkColor: PawfectCareTheme.primaryBlue,
            labelStyle: PawfectCareTheme.bodySmall.copyWith(
              color: isSelected
                  ? PawfectCareTheme.primaryBlue
                  : PawfectCareTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? PawfectCareTheme.primaryBlue
                    : PawfectCareTheme.dividerGray,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticlesList(List<Article> articles) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return _buildGridView(articles, 3);
        } else if (constraints.maxWidth > 800) {
          return _buildGridView(articles, 2);
        } else {
          return _buildListView(articles);
        }
      },
    );
  }

  Widget _buildGridView(List<Article> articles, int crossAxisCount) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) => _buildArticleCard(articles[index], true),
    );
  }

  Widget _buildListView(List<Article> articles) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) =>
          _buildArticleCard(articles[index], false),
    );
  }

  Widget _buildArticleCard(Article article, bool isGridView) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailPage(article: article),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildArticleImage(article, isGridView),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildArticleContent(article, isGridView),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleImage(Article article, bool isGridView) {
    return Container(
      height: isGridView ? 120 : 180,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            article.coverImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: PawfectCareTheme.chipBackground,
              child: Icon(
                Icons.pets,
                size: 48,
                color: PawfectCareTheme.primaryBlue.withValues(alpha: 0.5),
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: PawfectCareTheme.chipBackground,
                child: Center(
                  child: CircularProgressIndicator(
                    color: PawfectCareTheme.primaryBlue,
                    strokeWidth: 2,
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  // Handle favorite toggle
                },
                child: Icon(
                  Icons.favorite_border,
                  size: 20,
                  color: Colors.red[400],
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildArticleContent(Article article, bool isGridView) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          style: PawfectCareTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
          maxLines: isGridView ? 2 : 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          article.subtitle,
          style: PawfectCareTheme.bodyMedium.copyWith(
            color: PawfectCareTheme.textSecondary,
            fontStyle: FontStyle.italic,
            height: 1.3,
          ),
          maxLines: isGridView ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        if (!isGridView)
          Text(
            article.articleContent,
            style: PawfectCareTheme.bodySmall.copyWith(
              color: PawfectCareTheme.textSecondary,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        Row(
          children: [
            Icon(Icons.schedule, size: 16, color: PawfectCareTheme.textMuted),
            const SizedBox(width: 4),
            Text(
              _formatDate(article.createdAt),
              style: PawfectCareTheme.caption.copyWith(
                color: PawfectCareTheme.textMuted,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: PawfectCareTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Read More',
                    style: PawfectCareTheme.caption.copyWith(
                      color: PawfectCareTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: PawfectCareTheme.primaryBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: PawfectCareTheme.primaryBlue),
          const SizedBox(height: 16),
          Text(
            'Loading articles...',
            style: PawfectCareTheme.bodyMedium.copyWith(
              color: PawfectCareTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: PawfectCareTheme.errorRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: PawfectCareTheme.errorRed,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: PawfectCareTheme.headingSmall.copyWith(
                color: PawfectCareTheme.errorRed,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t load the articles. Please try again.',
              style: PawfectCareTheme.bodyMedium.copyWith(
                color: PawfectCareTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  // Trigger rebuild to retry
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PawfectCareTheme.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: PawfectCareTheme.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 40,
                color: PawfectCareTheme.primaryBlue.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No articles found',
              style: PawfectCareTheme.headingSmall.copyWith(
                color: PawfectCareTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms or category filter.'
                  : 'Check back later for new content!',
              style: PawfectCareTheme.bodyMedium.copyWith(
                color: PawfectCareTheme.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_searchQuery.isNotEmpty || _selectedCategory != 'All')
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _selectedCategory = 'All';
                    _searchController.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PawfectCareTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.clear_all, size: 20),
                label: const Text('Clear Filters'),
              ),
          ],
        ),
      ),
    );
  }
}
