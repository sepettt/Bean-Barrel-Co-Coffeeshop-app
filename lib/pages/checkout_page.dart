import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bean_barrel_co/pages/cart_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  String _paymentType = 'Online';
  bool isLoading = false;
  String orderNumber = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    if (user == null) return;

    DatabaseReference userRef = _database.ref().child('users').child(user!.uid);
    DataSnapshot snapshot = await userRef.get();
    setState(() {
      userName = snapshot.child('name').value as String;
    });
  }

  double getTotalPrice() {
    return CartPage.cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> _sendOrder() async {
    if (user == null || userName.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      DatabaseReference orderRef = _database.ref().child('orders').push();
      String uniqueOrderNumber = '#${DateTime.now().millisecondsSinceEpoch}-${orderRef.key?.substring(0, 3)}';
      double totalPrice = getTotalPrice();
      int pointsEarned = totalPrice.toInt(); // Assuming 1 point per RM 1 spent

      Map<String, dynamic> orderData = {
        'orderNumber': uniqueOrderNumber,
        'userId': user!.uid,
        'userName': userName,
        'items': CartPage.cartItems.map((item) => {
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'bean': item.bean,
          'milk': item.milk,
          'temperature': item.temperature,
          'syrup': item.syrup,
          'drizzle': item.drizzle,
          'totalPrice': item.totalPrice,
          'remark': item.remark,
        }).toList(),
        'paymentType': _paymentType,
        'timestamp': ServerValue.timestamp,
        'status': 'Order Sent',
      };

      // Save to Realtime Database
      await orderRef.set(orderData);

      // Save to Firestore
      await _firestore.collection('orders').add(orderData);

      // Update user points
      DatabaseReference userRef = _database.ref().child('users').child(user!.uid);
      DataSnapshot snapshot = await userRef.get();
      int currentPoints = (snapshot.child('points').value ?? 0) as int;
      int updatedPoints = currentPoints + pointsEarned;

      await userRef.update({'points': updatedPoints});

      setState(() {
        orderNumber = uniqueOrderNumber;
        isLoading = false;
      });

      // Clear the cart
      CartPage.cartItems.clear();

      _showOrderConfirmation(context);
    } catch (e) {
      print('Error sending order: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showOrderConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Confirmed'),
          content: Text('Your order number is $orderNumber'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Details',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: CartPage.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = CartPage.cartItems[index];
                        return ListTile(
                          title: Text('${item.name} x${item.quantity}',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          subtitle: Text(
                              'Total: ${item.totalPrice.toStringAsFixed(2)} RM',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total: RM ${getTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text('Payment Type',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  ListTile(
                    title: const Text('Online',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    leading: Radio<String>(
                      value: 'Online',
                      groupValue: _paymentType,
                      onChanged: (String? value) {
                        setState(() {
                          _paymentType = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Pay at Counter',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    leading: Radio<String>(
                      value: 'Pay at Counter',
                      groupValue: _paymentType,
                      onChanged: (String? value) {
                        setState(() {
                          _paymentType = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _sendOrder,
                      child: const Text('Confirm Order'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange, // Text color
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
