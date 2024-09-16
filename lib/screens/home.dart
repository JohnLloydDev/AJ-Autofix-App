import 'package:flutter/material.dart';
import 'package:aj_autofix/screens/booking.dart';
import 'package:aj_autofix/screens/contact_us.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:aj_autofix/screens/pendingrequest.dart';
import 'package:aj_autofix/screens/profile.dart';
import 'package:aj_autofix/screens/review.dart';
import 'package:aj_autofix/screens/shopmap.dart';

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

  // Track selected categories
  final Set<String> _selectedCategories = {};

  // Track selected services
  final Set<int> _selectedServices = {};

  List<Map<String, String>> services = [
    {'name': 'Power Window Motor', 'price': 'PHP 1,500', 'category': 'window'},
    {'name': 'Power Window Cable', 'price': 'PHP 900', 'category': 'window'},
    {'name': 'Door Lock Replacement', 'price': 'PHP 550', 'category': 'door'},
    {'name': 'Handle Replacement', 'price': 'PHP 700', 'category': 'door'},
    {'name': 'Door Lock Repair', 'price': 'PHP 400', 'category': 'door'},
    {'name': 'Handle Repair', 'price': 'PHP 500', 'category': 'door'},
    {'name': 'Powerlock 1pc', 'price': 'PHP 500', 'category': 'window'},
    {'name': 'Powerlock Set', 'price': 'PHP 2,000', 'category': 'window'},
    {'name': 'Car Alarm', 'price': 'PHP 1,500 - 1,800', 'category': 'window'},
  ];

  List<Map<String, String>> _filteredServices = [];

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
        final matchesCategory = _selectedCategories.isEmpty ||
            _selectedCategories.contains(service['category']);
        return name.contains(query) && matchesCategory;
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

  // Handle category button press
  void _onCategorySelected(String category) {
  setState(() {
    // If 'All' is selected, clear all categories
    if (category == 'all') {
      _selectedCategories.clear();
    } else {
      // If a specific category is selected, set it and clear 'All'
      _selectedCategories.clear();
      _selectedCategories.add(category);
    }

    _filterServices(); // Refresh the service list based on the selected category
  });
}

  // Toggle service selection
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
        title: Row(
          children: [
            Image.asset(
              'assets/a&j_logo_home.png', // Update with your image path
              height: 40, // Adjust height as needed
              fit: BoxFit.contain, // Ensure the image scales properly
            ),
          ],
        ),
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
                        builder: (context) => const ProfileScreen()));
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
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image above the search bar
            Container(
              width: double.infinity, // Stretch the container to the full width of its parent
              height: 100, // Set the height for the container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
                boxShadow: [
                  // Optional: add shadow for better appearance
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5.0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0), // Ensure the radius is applied to the image
                child: Image.asset(
                  'assets/repair.png',
                  width: double.infinity,
                  height: double.infinity, // Make the image fill the container
                  fit: BoxFit.cover, // Ensure the image scales properly
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search bar
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

            // Category text options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _categoryTextButton('All'),
                _categoryTextButton('Engine'),
                _categoryTextButton('Window'),
                _categoryTextButton('Door'),
              ],
            ),
            const SizedBox(height: 16),

            // Expanded GridView
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
                    isSelected: _selectedServices.contains(index),
                    onAddPressed: () => _toggleServiceSelection(index),
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

  // Create horizontal category buttons
  Widget _categoryTextButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: _selectedCategories.contains(category.toLowerCase()) ? Colors.white : Colors.black,
          backgroundColor: _selectedCategories.contains(category.toLowerCase()) ? Colors.purple : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () => _onCategorySelected(category.toLowerCase()),
        child: Text(category),
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
      color: Colors.white, // Change background color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center contents vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the start (left)
          children: [
            Text(
              serviceName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              servicePrice,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Spacer(), // Pushes the icon button to the bottom
            Align(
              alignment: Alignment.bottomRight, // Align the icon to the bottom-right
              child: IconButton(
                onPressed: onAddPressed,
                icon: Icon(
                  isSelected ? Icons.check_circle : Icons.add_circle,
                  color: isSelected ? Colors.green : Colors.black,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringCapitalize on String {
  String capitalize() {
    if (this.isEmpty) {
      return '';
    }
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
