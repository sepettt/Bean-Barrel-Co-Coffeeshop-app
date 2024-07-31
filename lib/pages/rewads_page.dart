import 'package:bean_barrel_co/pages/home_page.dart';
import 'package:bean_barrel_co/pages/ordered_page.dart';
import 'package:bean_barrel_co/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  User? user;
  int points = 0;
  String ranking = 'Beginner';

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _fetchUserPoints();
  }

  Future<void> _fetchUserPoints() async {
    if (user == null) return;

    DatabaseReference userRef = _database.ref().child('users').child(user!.uid);
    DataSnapshot snapshot = await userRef.get();
    setState(() {
      points = snapshot.child('points').value as int? ?? 0;
      if (points >= 1000) {
        ranking = 'Pro';
      } else if (points >= 500) {
        ranking = 'Amateur';
      } else {
        ranking = 'Beginner';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Rewards', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white), // Back button color

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Points', style: TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(points.toString(), style: const TextStyle(fontSize: 36, color: Colors.white)),
            const SizedBox(height: 20),
            const Text('Your Ranking', style: TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(ranking, style: const TextStyle(fontSize: 36, color: Colors.white)),
            const SizedBox(height: 20),
            const Text('Rewards to Redeem', style: TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  RewardTile(
                    rewardName: 'Free Coffee',
                    requiredPoints: 100,
                    userPoints: points,
                  ),
                  RewardTile(
                    rewardName: 'Discount Voucher',
                    requiredPoints: 500,
                    userPoints: points,
                  ),
                  RewardTile(
                    rewardName: 'Premium Coffee Mug',
                    requiredPoints: 1000,
                    userPoints: points,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: 2, // Assuming this is the index for ProfilePage
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
            // Navigate to the profile page
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => RewardsPage()),
            //   );
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
            icon: Icon(Icons.list_alt, color: Colors.white),
            label: 'Ordered',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard,color: Colors.orange),
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

class RewardTile extends StatelessWidget {
  final String rewardName;
  final int requiredPoints;
  final int userPoints;

  const RewardTile({
    super.key,
    required this.rewardName,
    required this.requiredPoints,
    required this.userPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(rewardName, style: const TextStyle(color: Colors.white)),
        subtitle: Text('Required Points: $requiredPoints', style: const TextStyle(color: Colors.grey)),
        trailing: ElevatedButton(
          onPressed: userPoints >= requiredPoints ? () {} : null,
          child: const Text('Redeem'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: userPoints >= requiredPoints ? Colors.orange : Colors.grey,
          ),
        ),
      ),
    );
  }
}
