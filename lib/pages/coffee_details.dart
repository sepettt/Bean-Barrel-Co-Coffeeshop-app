import 'package:flutter/material.dart';
import 'cart_page.dart';

class CoffeeDetailsPage extends StatefulWidget {
  final String imagePath;
  final String name;
  final String description;
  final String price;

  const CoffeeDetailsPage({
    super.key,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  _CoffeeDetailsPageState createState() => _CoffeeDetailsPageState();
}

class _CoffeeDetailsPageState extends State<CoffeeDetailsPage> {
  int quantity = 1;
  String selectedBean = 'Arabica';
  String selectedMilk = 'None';
  String selectedTemperature = 'Hot';
  String selectedSyrup = 'None';
  String selectedDrizzle = 'None';
  final TextEditingController remarkController = TextEditingController();
  String remark = '';

  final List<String> beans = ['None','Arabica', 'Robusta', 'Liberica'];
  final List<String> milks = ['None', 'Whole Milk', 'Soy Milk', 'Almond Milk'];
  final List<String> temperatures = ['Hot', 'Cold'];
  final List<String> syrups = ['None', 'Vanilla RM 2', 'Caramel RM 2', 'Hazelnut RM 2'];
  final List<String> drizzles = ['None', 'Caramel RM 2', 'Chocolate RM 2'];

  double get totalPrice {
    double basePrice = double.parse(widget.price.replaceAll(RegExp(r'[^\d.]'), ''));
    double extraCost = 0;
    if (selectedSyrup != 'None') extraCost += 2;
    if (selectedDrizzle != 'None') extraCost += 2;
    return (basePrice + extraCost) * quantity;
  }

  void addToCart() {
    final cartItem = CartItem(
      name: widget.name,
      price: widget.price,
      quantity: quantity,
      bean: selectedBean,
      milk: selectedMilk,
      temperature: selectedTemperature,
      syrup: selectedSyrup,
      drizzle: selectedDrizzle,
      totalPrice: totalPrice,
      remark: remarkController.text,
    );
    CartPage.addToCart(cartItem);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(widget.imagePath),
            const SizedBox(height: 20),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              widget.price,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quantity', style: TextStyle(fontSize: 18, color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                        ),
                        child: Icon(Icons.remove, color: Colors.orange),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('$quantity', style: const TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                        ),
                        child: Icon(Icons.add, color: Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Type of Bean', style: TextStyle(fontSize: 18, color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: selectedBean,
                      dropdownColor: Colors.grey[800],
                      onChanged: (value) {
                        setState(() {
                          selectedBean = value!;
                        });
                      },
                      items: beans.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      isExpanded: true,
                      underline: Container(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Type of Milk', style: TextStyle(fontSize: 18, color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: selectedMilk,
                      dropdownColor: Colors.grey[800],
                      onChanged: (value) {
                        setState(() {
                          selectedMilk = value!;
                        });
                      },
                      items: milks.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      isExpanded: true,
                      underline: Container(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Temperature', style: TextStyle(fontSize: 18, color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: selectedTemperature,
                      dropdownColor: Colors.grey[800],
                      onChanged: (value) {
                        setState(() {
                          selectedTemperature = value!;
                        });
                      },
                      items: temperatures.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      isExpanded: true,
                      underline: Container(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Add Syrup', style: TextStyle(fontSize: 18, color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: selectedSyrup,
                      dropdownColor: Colors.grey[800],
                      onChanged: (value) {
                        setState(() {
                          selectedSyrup = value!;
                        });
                      },
                      items: syrups.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      isExpanded: true,
                      underline: Container(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Add Drizzle', style: TextStyle(fontSize: 18, color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: selectedDrizzle,
                      dropdownColor: Colors.grey[800],
                      onChanged: (value) {
                        setState(() {
                          selectedDrizzle = value!;
                        });
                      },
                      items: drizzles.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      isExpanded: true,
                      underline: Container(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Remark for Barista', style: TextStyle(fontSize: 18, color: Colors.white)),
                  TextField(
                    controller: remarkController,
                    maxLength: 300,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Enter your remark here',
                      hintStyle: TextStyle(color: Colors.white54),
                      counterStyle: TextStyle(color: Colors.white54),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add to Cart',
                  style: TextStyle(color: Colors.black,)),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
