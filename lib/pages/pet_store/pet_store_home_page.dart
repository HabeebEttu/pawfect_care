import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:provider/provider.dart' as pr;
import 'package:pawfect_care/models/cart_item.dart';
import 'package:pawfect_care/models/pet_store_item.dart';
import 'package:pawfect_care/pages/pet_store/cart_page.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/providers/pet_store_provider.dart';

class PetStoreHomePage extends rp.ConsumerStatefulWidget {
  const PetStoreHomePage({super.key});

  @override
  rp.ConsumerState<PetStoreHomePage> createState() => _PetStoreHomePageState();
}

class _PetStoreHomePageState extends rp.ConsumerState<PetStoreHomePage> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productsProvider);
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: productsAsyncValue.when(
        data: (products) {
          List<PetStoreItem> filteredProducts = products;
          if (_selectedCategory != null && _selectedCategory != 'All') {
            filteredProducts = filteredProducts
                .where((product) => product.category == _selectedCategory)
                .toList();
          }

          return Column(
            children: [
              // Category Filter
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: _selectedCategory,
                  items: ['All', ...categoriesAsyncValue.value ?? []].map((
                    category,
                  ) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
              ),
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(child: Text('No products found.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Card(
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(product.price.toStringAsFixed(2)),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(
                                          icon: const Icon(Icons.add_shopping_cart),
                                          onPressed: () {
                                            final authProvider =
                                                pr.Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false,
                                                );
                                            if (authProvider.user == null) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Please log in to add items to cart.')),
                                              );
                                              return;
                                            }
                                            final cartItem = CartItem(
                                              id: product.id,
                                              item: product,
                                              quantity: 1,
                                            );
                                            // Add to cart using cart provider
                                            ref
                                                .read(cartProvider.notifier)
                                                .addToCart(
                                                  authProvider.user!.uid,
                                                  cartItem,
                                                );
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Added ${product.name} to cart!')),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
