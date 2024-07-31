import 'package:bean_barrel_co/pages/home_page.dart';
import 'package:bean_barrel_co/pages/profile_page.dart';
import 'package:bean_barrel_co/pages/rewads_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bean_barrel_co/pages/order_detail_page.dart';

class OrderedPage extends StatelessWidget {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  OrderedPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Orders', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      body: user == null
          ? Center(child: Text('Please log in to see your orders.', style: TextStyle(color: Colors.white)))
          : StreamBuilder(
              stream: _database.ref().child('orders').orderByChild('userId').equalTo(user!.uid).onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && (snapshot.data!.snapshot.value != null)) {
                  Map orders = (snapshot.data as DatabaseEvent).snapshot.value as Map;
                  List<Map<String, dynamic>> ongoingOrders = [];
                  List<Map<String, dynamic>> historyOrders = [];

                  orders.forEach((key, value) {
                    if (value['status'] == 'Order Sent' || value['status'] == 'Brewing') {
                      ongoingOrders.add({'key': key, 'order': value});
                    } else if (value['status'] == 'Order Complete') {
                      historyOrders.add({'key': key, 'order': value});
                    }
                  });

                  return ListView(
                    padding: EdgeInsets.all(16.0),
                    children: [
                      if (ongoingOrders.isNotEmpty)
                        Text(
                          'Ongoing Orders',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      if (ongoingOrders.isNotEmpty)
                        ...ongoingOrders.map((order) {
                          return ListTile(
                            title: Text('Order ${order['order']['orderNumber']}', style: TextStyle(color: Colors.white)),
                            subtitle: Text('Status: ${order['order']['status']}', style: TextStyle(color: Colors.grey)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailPage(orderId: order['key'], orderData: order['order']),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      if (historyOrders.isNotEmpty)
                        SizedBox(height: 20),
                      if (historyOrders.isNotEmpty)
                        Text(
                          'Order History',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      if (historyOrders.isNotEmpty)
                        ...historyOrders.map((order) {
                          return ListTile(
                            title: Text('Order ${order['order']['orderNumber']}', style: TextStyle(color: Colors.white)),
                            subtitle: Text('Status: ${order['order']['status']}', style: TextStyle(color: Colors.grey)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailPage(orderId: order['key'], orderData: order['order']),
                                ),
                              );
                            },
                          );
                        }).toList(),
                    ],
                  );
                }

                return Center(child: Text('No orders found.', style: TextStyle(color: Colors.white)));
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: 1, // Assuming this is the index for OrderedPage
        selectedItemColor: Colors.orange, // Selected item color
        unselectedItemColor: Colors.white, // Unselected item color
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to HomePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            // case 1: // Handled by currentIndex
            //   // Already on OrderedPage, do nothing
            //   break;
            case 2:
              // Navigate to ProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RewardsPage()),
              );
              break;
             case 3:
            // Navigate to the rewards page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            break; 
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt, color: Colors.orange),
            label: 'Ordered',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard,color: Colors.white),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed, // Ensures background remains transparent

      ),
    );
  }
}
