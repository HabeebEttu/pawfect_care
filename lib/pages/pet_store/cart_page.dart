import 'package:flutter/material.dart';
import 'package:pawfect_care/providers/auth_provider.dart';
import 'package:pawfect_care/providers/pet_store_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        Provider.of<PetStoreProvider>(context, listen: false).fetchCart(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final petStoreProvider = Provider.of<PetStoreProvider>(context);

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

    double totalAmount = petStoreProvider.cartItems.fold(0.0, (sum, item) => sum + (item.item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () async {
              await petStoreProvider.clearCart(authProvider.user!.uid);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart cleared!')),
              );
            },
          ),
        ],
      ),
      body: petStoreProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : petStoreProvider.cartItems.isEmpty
              ? const Center(child: Text('Your cart is empty.'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: petStoreProvider.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = petStoreProvider.cartItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: Image.network(item.item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                              title: Text(item.item.name),
                              subtitle: Text('Quantity: ${item.quantity} - \${(item.item.price * item.quantity).toStringAsFixed(2)}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_shopping_cart, color: Colors.red),
                                onPressed: () async {
                                  await petStoreProvider.removeFromCart(authProvider.user!.uid, item.id);
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
                            'Total: \$${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await petStoreProvider.placeOrder(authProvider.user!.uid, petStoreProvider.cartItems, totalAmount);
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
