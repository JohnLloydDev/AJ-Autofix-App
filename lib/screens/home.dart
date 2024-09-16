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

  final Set<String> _selectedCategories = {};

  final Set<int> _selectedServices = {};

  List<Map<String, String>> services = [
  // Window
  {'name': 'Power Window Motor', 'price': 'PHP 1,500', 'category': 'window'},
  {'name': 'Power Window Cable', 'price': 'PHP 900', 'category': 'window'},
  {'name': 'Powerlock 1pc', 'price': 'PHP 500', 'category': 'window'},
  {'name': 'Powerlock Set', 'price': 'PHP 2,000', 'category': 'window'},
  // Door
  {'name': 'Door Lock Replacement', 'price': 'PHP 550', 'category': 'door'},
  {'name': 'Handle Replacement', 'price': 'PHP 700', 'category': 'door'},
  {'name': 'Door Lock Repair', 'price': 'PHP 400', 'category': 'door'},
  {'name': 'Handle Repair', 'price': 'PHP 500', 'category': 'door'},
  // Engine category
  {'name': 'Coolant Flush', 'price': 'PHP 1,200', 'category': 'engine'},
  {'name': 'Engine Oil Change', 'price': 'PHP 1,000', 'category': 'engine'},
  {'name': 'Spark Plug Replacement', 'price': 'PHP 800', 'category': 'engine'},
  {'name': 'Air Filter Replacement', 'price': 'PHP 600', 'category': 'engine'},
  {'name': 'Fuel Injector Cleaning', 'price': 'PHP 2,200', 'category': 'engine'},
  {'name': 'Timing Belt Replacement', 'price': 'PHP 4,500', 'category': 'engine'},
  // Wheel category
  {'name': 'Tire Replacement', 'price': 'PHP 3,500', 'category': 'wheel'},
  {'name': 'Wheel Alignment', 'price': 'PHP 1,200', 'category': 'wheel'},
  {'name': 'Brake Pad Replacement', 'price': 'PHP 1,800', 'category': 'wheel'},
  {'name': 'Brake Fluid Replacement', 'price': 'PHP 600', 'category': 'wheel'},
  // Electrical category
  {'name': 'Alternator Repair', 'price': 'PHP 3,500', 'category': 'electrical'},
  {'name': 'Fuse Replacement', 'price': 'PHP 300', 'category': 'electrical'},
  {'name': 'Car Alarm', 'price': 'PHP 1,500 - 1,800', 'category': 'electrical'},
  {'name': 'Battery Replacement', 'price': 'PHP 4,000', 'category': 'electrical'},
  {'name': 'Headlight Bulb Replacement', 'price': 'PHP 500', 'category': 'electrical'},
  {'name': 'Power Window Switch Repair', 'price': 'PHP 1,000', 'category': 'electrical'}
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
      case 1: 
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Booking()),
        );
        break;
      case 2: 
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShopMap()),
        );
        break;
      default:
        break;
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (category == 'all') {
        _selectedCategories.clear();
      } else {
        _selectedCategories.clear();
        _selectedCategories.add(category);
      }

      _filterServices();
    });
  }

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
              'assets/a&j_logo_home.png', 
              height: 40, 
              fit: BoxFit.contain, 
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
              height: 100, 
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF9FA8DA), 
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
            Container(
              width: double
                  .infinity, 
              height: 100, 
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(16.0), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5.0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    16.0), 
                child: Image.asset(
                  'assets/repair.png',
                  width: double.infinity,
                  height: double.infinity, 
                  fit: BoxFit.cover, 
                ),
              ),
            ),
            const SizedBox(height: 16),

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

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _categoryTextButton('All'),
                  _categoryTextButton('Engine'),
                  _categoryTextButton('Window'),
                  _categoryTextButton('Door'),
                  _categoryTextButton('Wheel'),
                  _categoryTextButton('Electrical'),
                ],
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

  Widget _categoryTextButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: _selectedCategories.contains(category.toLowerCase())
              ? Colors.white
              : Colors.black,
          backgroundColor: _selectedCategories.contains(category.toLowerCase())
              ? Colors.purple
              : Colors.grey[300],
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
      color: Colors.white, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            Text(
              serviceName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              servicePrice,
              textAlign: TextAlign.center, 
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Spacer(), 
            Align(
              alignment:
                  Alignment.bottomRight, 
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
