import 'package:bean_barrel_co/pages/ordered_page.dart';
import 'package:bean_barrel_co/pages/rewads_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bean_barrel_co/pages/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  User? user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    user = _auth.currentUser;
    if (user != null) {
      await getUserProfile();
    }
  }

  Future<void> getUserProfile() async {
    try {
      DatabaseReference userRef = _database.ref().child('users/${user!.uid}');
      DataSnapshot snapshot = await userRef.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _genderController.text = userData['gender'] ?? '';
          _birthdayController.text = userData['birthday'] ?? '';
          isLoading = false;
        });
      } else {
        // Initialize the data if it doesn't exist
        await userRef.set({
          'name': user!.displayName ?? 'User',
          'email': user!.email,
          'phone': '',
          'gender': '',
          'birthday': '',
        });
        setState(() {
          _nameController.text = user!.displayName ?? 'User';
          _emailController.text = user!.email!;
          _phoneController.text = '';
          _genderController.text = '';
          _birthdayController.text = '';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error getting user profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (user != null) {
      try {
        DatabaseReference userRef = _database.ref().child('users/${user!.uid}');
        await userRef.update({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'gender': _genderController.text,
          'birthday': _birthdayController.text,
        });

        // Update the user's email in FirebaseAuth
        await user!.updateEmail(_emailController.text);
      } catch (e) {
        print('Error updating profile: $e');
        // Handle error, e.g., show a message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white), // Back button color
      ),
      backgroundColor: Colors.grey[900],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Name'),
                    _buildTextField(_emailController, 'Email'),
                    _buildTextField(_phoneController, 'Phone'),
                    _buildTextField(_genderController, 'Gender'),
                    _buildTextField(_birthdayController, 'Birthday'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('Update Profile',
                      style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: 3, // Assuming this is the index for ProfilePage
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
            case 1:
              // Navigate to OrderedPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderedPage()),
              );
              break;
              case 2:
            // Navigate to the rewards page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RewardsPage()),
            );
            break;
            // case 2: // Handled by currentIndex
            //   // Already on ProfilePage, do nothing
            //   break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt, color: Colors.white),
            label: 'Ordered',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard,color: Colors.white),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.orange),
            label: 'Profile',
          ),
        ],
       type: BottomNavigationBarType.fixed, // Ensures background remains transparent

      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
