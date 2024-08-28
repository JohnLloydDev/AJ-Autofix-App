import 'package:aj_autofix/screens/booking.dart';
import 'package:aj_autofix/screens/contact_us.dart';
import 'package:aj_autofix/screens/login.dart';
import 'package:aj_autofix/screens/pendingrequest.dart';
import 'package:aj_autofix/screens/review.dart';
import 'package:aj_autofix/screens/shopmap.dart';
import 'package:aj_autofix/screens/viewprofile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E & J Autofix',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false, 
      home: const HomeScreen(),
    );
  }
}

//search ito
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the appropriate page based on the selected index
    switch (index) {
      case 1: // Booking tab
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Booking()),
        );
        break;
      case 2: // Map tab
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShopMap()),
        );
        break;
      default:
        // Home tab or other tabs
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, 
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('E & J Autofix'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer(); 
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 100, // Adjusting the height 
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF9FA8DA), 
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileView()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.pending),
              title: const Text('Pending'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserPendingRequest()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactUsScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Reviews'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReviewScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search for a car service',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: 8, // Number of items in the grid
                itemBuilder: (context, index) {
                  return const ServiceCard(); // Use const for better performance
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Change Oil',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text('PHP 100'),
            ElevatedButton(
              onPressed: () {
                // Handle the add button press
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
      ),
      body: const Center(
        child: Text('Booking Page'),
      ),
    );
  }
}
