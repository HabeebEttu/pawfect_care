import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:provider/provider.dart' as pr;
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/providers/pet_store_provider.dart';

class CartPage extends rp.ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  rp.ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends rp.ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = pr.Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        ref.read(cartProvider.notifier).fetchCart(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = pr.Provider.of<AuthProvider>(context);
    final cart = ref.watch(cartProvider);

    if (authProvider.user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
        ),
        body: const Center(
          child: Text('Please log in to view your cart.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () async {
              await ref
                  .read(cartProvider.notifier)
                  .clearCart(authProvider.user!.uid);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart cleared!')),
              );
            },
          ),
        ],
      ),
      body: cart.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cart.items.isEmpty
              ? const Center(child: Text('Your cart is empty.'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                    itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                      final item = cart.items[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: Image.network(item.item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                              title: Text(item.item.name),
                              subtitle: Text('Quantity: ${item.quantity} - \${(item.item.price * item.quantity).toStringAsFixed(2)}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_shopping_cart, color: Colors.red),
                                onPressed: () async {
                              await ref
                                  .read(cartProvider.notifier)
                                  .removeFromCart(
                                    authProvider.user!.uid,
                                    item.id,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Removed ${item.item.name} from cart.')),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                        'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                          await ref
                              .read(cartProvider.notifier)
                              .placeOrder(
                                authProvider.user!.uid,
                                cart.items,
                                cart.totalAmount,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Order placed successfully!')),
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Checkout'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
