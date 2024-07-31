import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderId;
  final Map<dynamic, dynamic> orderData;

  const OrderDetailPage({super.key, required this.orderId, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Order Details',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Number: ${orderData['orderNumber']}', style: const TextStyle(fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Status: ${orderData['status']}', style: const TextStyle(color: Colors.white,fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Items:', style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
            ...orderData['items'].map<Widget>((item) {
              return ListTile(
                title: Text('${item['name']} x${item['quantity']}',style: TextStyle(color: Colors.white),),
                subtitle: Text('Total: ${item['totalPrice'].toStringAsFixed(2)} RM',style: TextStyle(color: Colors.white),),
              );
            }).toList(),
            const SizedBox(height: 20),
            Text('Payment Type: ${orderData['paymentType']}', style: const TextStyle(color: Colors.white,fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
