import 'package:aj_autofix/screens/booking.dart';
import 'package:aj_autofix/screens/contact_us.dart';
import 'package:aj_autofix/screens/login_screen.dart';
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
      title: 'A & J Autofix',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, String>> services = [
    {'name': 'Power Window Motor', 'price': 'PHP 1,500'},
    {'name': 'Power Window Cable', 'price': 'PHP 900'},
    {'name': 'Door Lock Replacement', 'price': 'PHP 550'},
    {'name': 'Handle Replacement', 'price': 'PHP 700'},
    {'name': 'Door Lock Repair', 'price': 'PHP 400'},
    {'name': 'Handle Repair', 'price': 'PHP 500'},
    {'name': 'Powerlock 1pc', 'price': 'PHP 500'},
    {'name': 'Powerlock Set', 'price': 'PHP 2,000'},
    {'name': 'Car Alarm', 'price': 'PHP 1,500 - 1,800'},
  ];

  List<Map<String, String>> _filteredServices = [];
  
  // Track selected services
  final Set<int> _selectedServices = {};

  @override
  void initState() {
    super.initState();
    _filteredServices = services;
    _searchController.addListener(_filterServices);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterServices);
    _searchController.dispose();
    super.dispose();
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredServices = services.where((service) {
        final name = service['name']!.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

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

  // Toggle the selection of a service
  void _toggleServiceSelection(int index) {
    setState(() {
      if (_selectedServices.contains(index)) {
        _selectedServices.remove(index);
      } else {
        _selectedServices.add(index);
      }
    });
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
                  color: Color(0xFF9FA8DA), // Light blue color for header
                ),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
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
              controller: _searchController,
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
                itemCount: _filteredServices.length,
                itemBuilder: (context, index) {
                  return ServiceCard(
                    serviceName: _filteredServices[index]['name']!,
                    servicePrice: _filteredServices[index]['price']!,
                    isSelected: _selectedServices.contains(index), // Check if the service is selected
                    onAddPressed: () => _toggleServiceSelection(index), // Handle the add button press
                  );
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
  final String serviceName;
  final String servicePrice;
  final bool isSelected;
  final VoidCallback onAddPressed;

  const ServiceCard({
    super.key,
    required this.serviceName,
    required this.servicePrice,
    required this.isSelected,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: isSelected ? Colors.green[100] : Colors.lightBlue[50], // Highlight if selected
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center contents vertically
          children: [
            Text(
              serviceName,
              textAlign: TextAlign.center, // Center text horizontally
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              servicePrice,
              textAlign: TextAlign.center, // Center text horizontally
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onAddPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: isSelected ? Colors.green : Colors.blue, // Change button color if selected
                minimumSize: const Size(double.infinity, 40), // Button height
              ),
              child: Text(isSelected ? 'SELECTED' : 'ADD'),
            ),
          ],
        ),
      ),
    );
  }
}
