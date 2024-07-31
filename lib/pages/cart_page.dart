import 'package:bean_barrel_co/pages/checkout_page.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String price;
  final int quantity;
  final String bean;
  final String milk;
  final String temperature;
  final String syrup;
  final String drizzle;
  final double totalPrice;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.bean,
    required this.milk,
    required this.temperature,
    required this.syrup,
    required this.drizzle,
    required this.totalPrice, 
    required String remark,
  });

  get remarkController => null;

  get remark => null;
}

class CartPage extends StatelessWidget {
  static final List<CartItem> cartItems = [];

  static void addToCart(CartItem item) {
    cartItems.add(item);
  }

  const CartPage({super.key});

  double getTotalPrice() {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            title: Text(
              '${item.name} x${item.quantity}',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Total: ${item.totalPrice.toStringAsFixed(2)} RM',
              style: TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                cartItems.removeAt(index);
                // ignore: invalid_use_of_protected_member
                (context as Element).reassemble();
              },
              
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total: ${getTotalPrice().toStringAsFixed(2)} RM',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckoutPage()),
                  );
                },
                child: const Text('Proceed to Checkout'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
