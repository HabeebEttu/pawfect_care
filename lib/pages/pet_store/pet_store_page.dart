import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/pages/pet_store/widgets/category_selector.dart';
import 'package:pawfect_care/pages/pet_store/widgets/store_card.dart';
import 'package:pawfect_care/pages/pet_store/widgets/store_search_bar.dart';
import 'package:pawfect_care/providers/blog_provider.dart' as blog_provider;
import 'package:pawfect_care/providers/pet_store_provider.dart';
import 'package:pawfect_care/widgets/empty_state.dart';
import 'package:pawfect_care/widgets/error_state.dart';
import 'package:pawfect_care/widgets/grid_skeleton_loading.dart';

class PetStorePage extends ConsumerStatefulWidget {
  const PetStorePage({super.key});

  @override
  ConsumerState<PetStorePage> createState() => _PetStorePageState();
}

class _PetStorePageState extends ConsumerState<PetStorePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth ~/ 220).clamp(1, 6);
    final categoriesAsync = ref.watch(categoriesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final petStoreAsync = ref.watch(filteredPetStoreProvider);

    return Scaffold(
      body: Column(
        children: [
          StoreSearchBar(
            controller: _searchController,
            onChanged: (value) =>
            ref.read(searchQueryProvider.notifier).state = value,
            searchQuery: searchQuery,
          ),
          categoriesAsync.when(
            data: (categories) => CategorySelector(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (cat) =>
              ref.read(selectedCategoryProvider.notifier).state = cat,
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            error: (err, _) => Text('Error: $err'),
          ),
          Expanded(
            child: petStoreAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyState();
                }

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    return StoreCard(
                      item: items[index],
                      index: index,
                    );
                  },
                );
              },
              loading: () => const GridSkeletonLoading(),
              error: (e, s) => ErrorState(
                icon: Icons.broken_image_outlined,
                message: 'Unable to load: $e',
              ),
            ),
          )

        ],
      ),
    );
  }
}
