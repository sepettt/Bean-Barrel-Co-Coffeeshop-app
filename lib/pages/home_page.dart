// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bean_barrel_co/pages/cart_page.dart';
import 'package:bean_barrel_co/pages/coffee_details.dart';
import 'package:bean_barrel_co/pages/login_page.dart';
import 'package:bean_barrel_co/pages/ordered_page.dart';
import 'package:bean_barrel_co/pages/profile_page.dart';
import 'package:bean_barrel_co/pages/rewads_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  final List<String> promoImages = [
    'lib/images/promo1.png',
    'lib/images/promo2.png',
    'lib/images/promo3.png',
  ];

  final List latte = [
    // [ coffeImagePath, coffeName, coffeDescription, coffePrice ]
    [
      'lib/images/latte-with-coffee-beans-table.jpg',
      'Latte',
      'With Coffee Beans',
      'RM 7.99'
    ],
    [
      'lib/images/latte-with-coffee-beans-table.jpg',
      'Spanish Latte',
      'With Coffee Beans',
      'RM 7.99'
    ],
    [
      'lib/images/latte-coffee-beans-side-view.jpg',
      'Latte Almond',
      'With Almond Milk',
      'RM 8.99'
    ],
    [
      'lib/images/coffee-milk-latte-with-strawberry-slices.jpg',
      'Latte Strawberry',
      'With strawberry slices',
      'RM 8.99'
    ],
  ];

  final List matcha = [
    [
      'lib/images/matcha latte.png',
      'Matcha Latte',
      'matcha latte',
      'RM 8.99'
    ],
    [
      'lib/images/matcha latte.png',
      'Matcha Lemonade',
      'matcha lemonade',
      'RM 8.99'
    ],
    [
      'lib/images/matcha latte.png',
      'Japanese Matcha',
      'japanese matcha',
      'RM 8.99'
    ],
    [
      'lib/images/matcha latte.png',
      'Matcha Strawberry ',
      'matcha strawberry latte',
      'RM 8.99'
    ],
  ];

  final List frappucino = [
    [
      'lib/images/frappe.png',
      'Latte Frappe ',
      'latte frappucino',
      'RM 8.99',
    ],
    [
      'lib/images/frappe.png',
      "Strawberry Frappe ",
      'strawberry frappucino',
      'RM 8.99',
    ],
    [
      'lib/images/frappe.png',
      'Mango Frappe ',
      'mango frappucino',
      'RM 8.99',
    ],
    [
      'lib/images/frappe.png',
      'Java Chip Frappe ',
      'java chip frappucino',
      'RM 8.99',
    ],
  ];

  final List black = [
    [
      'lib/images/morning-with-turkish-coffee-brewing.jpg',
      'Americano',
      'Americano Coffee',
      'RM 8.99'
    ],
    [
      'lib/images/person-serving-cup-coffee-with-metal-jug.jpg',
      'Espresso',
      'espresso coffee',
      'RM 8.99'
    ],
    [
      'lib/images/person-serving-cup-coffee-with-metal-jug.jpg',
      'Long Black',
      'long black coffee',
      'RM 8.99'
    ],
  ];

  // overall coffe summary
  late List coffeeTileList = latte;
  // list of coffe types
  final List coffeeType = [
    // [coffee type, isSelected]
    [
      'Latte',
      true,
    ],
    [
      'Matcha',
      false,
    ],
    [
      'Frappucino',
      false,
    ],
    [
      'Black',
      false,
    ],
  ];

  // user tapped on coffe types
  void coffeeTypesSelected(int index) {
    setState(() {
      //this for loop makes every selection flase
      for (int i = 0; i < coffeeType.length; i++) {
        coffeeType[i][1] = false;
      }
      coffeeType[index][1] = true;
      // Update coffeeTileList based on the selected coffee type
      switch (coffeeType[index][0]) {
        case 'Latte':
          coffeeTileList = latte;
          break;
        case 'Espresso':
          coffeeTileList = matcha;
          break;
        case 'Cappucino':
          coffeeTileList = frappucino;
          break;
        case 'Black':
          coffeeTileList = black;
          break;
      }
    });
  }

  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        // Already on HomePage, do nothing
        break;
      case 1:
        // Navigate to the ordered page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderedPage()),
        );
        break;
      case 2:
        // Navigate to the profile page
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Bean Barrel Co', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 169, 165, 165),
                size: 30,
              ),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Color.fromARGB(255, 169, 165, 165),
                size: 30,
              ),
              onPressed: () {
                // Navigate to cart page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
            ),
          ),
        ],
        // leading: Icon(Icons.menu),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange, // Selected item color
        unselectedItemColor: Colors.white, // Unselected item color
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Ordered',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          
        ],
        type: BottomNavigationBarType.fixed, // Ensures background remains transparent
      ),
      body: Column(
        children: [
          // Image slider
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            items: promoImages.map((item) => Container(
              child: Center(
                child: Image.asset(
                  item,
                  fit: BoxFit.cover,
                  width: 1000,
                ),
              ),
            )).toList(),
          ),
        
          //Find the best coffee for you
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          //   child: Text(
          //     "Find the best coffee for you",
          //     style: TextStyle(fontSize: 35, color: Colors.white),
          //   ),
          // ),
          SizedBox(
            height: 25,
          ),
          // Horizantal listview of coffee
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: coffeeType.length,
              itemBuilder: ((context, index) {
                return CoffeeType(
                  coffeeType: coffeeType[index][0],
                  isSelected: coffeeType[index][1],
                  onTap: () {
                    coffeeTypesSelected(index);
                    if (coffeeType[index][1] && coffeeType[index][0] == "Latte") {
                      coffeeTileList = latte;
                    } else if (coffeeType[index][1] && coffeeType[index][0] == "Matcha") {
                      coffeeTileList = matcha;
                    } else if (coffeeType[index][1] && coffeeType[index][0] == "Frappucino") {
                      coffeeTileList = frappucino;
                    } else if (coffeeType[index][1] && coffeeType[index][0] == "Black") {
                      coffeeTileList = black;
                    }
                  },
                );
              }),
            ),
          ),
          // Horizantal listview of coffee tiles
          Expanded(
            child: ListView.builder(
              itemCount: coffeeTileList.length,
              itemBuilder: (context, index) {
                return CoffeeTile(
                  imagePath: coffeeTileList[index][0],
                  name: coffeeTileList[index][1],
                  description: coffeeTileList[index][2],
                  price: coffeeTileList[index][3],
                );
              },
            ),
            ),
        ]
      ),
    );
  }
}

class CoffeeType extends StatelessWidget {
  final String coffeeType;
  final bool isSelected;
  final VoidCallback onTap;

  const CoffeeType({
    super.key,
    required this.coffeeType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: Text(
          coffeeType,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.orange : Colors.white,
          ),
        ),
      ),
    );
  }
}

class CoffeeTile extends StatelessWidget {
  final String imagePath;
  final String name;
  final String description;
  final String price;

  const CoffeeTile({
    super.key,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoffeeDetailsPage(
                imagePath: imagePath,
                name: name,
                description: description,
                price: price,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[800],
          ),
          child: Row(
            children: [
              //coffee image
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20),
              //coffee name and price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
