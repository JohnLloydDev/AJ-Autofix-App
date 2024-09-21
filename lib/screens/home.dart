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
  final Set<String> _selectedServices = {};

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

  void _toggleServiceSelection(String serviceName) {
    setState(() {
      if (_selectedServices.contains(serviceName)) {
        _selectedServices.remove(serviceName); // Deselect if already selected
      } else {
        _selectedServices.add(serviceName); // Add to selected if not selected
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
                  childAspectRatio: 0.9,
                ),
                itemCount: _filteredServices.length,
                itemBuilder: (context, index) {
                  final service = _filteredServices[index];
                  final serviceName = service['name']!;

                  // Determine if the service is selected based on global state
                  final isSelected = _selectedServices.contains(serviceName);

                  // Determine the image path for the service
                  String? imagePath;
                  if (serviceName == 'Power Window Motor') {
                    imagePath = 'assets/motor.png';
                  } else if (serviceName == 'Power Window Cable') {
                    imagePath = 'assets/cable.png';
                  } else if (serviceName == 'Powerlock 1pc') {
                    imagePath = 'assets/power_lock_1pc.jpg';
                  } else if (serviceName == 'Powerlock Set') {
                    imagePath = 'assets/power_lock_set.png';
                  } else if (serviceName == 'Door Lock') {
                    imagePath = 'assets/door_lock.png';
                  } else if (serviceName == 'Handle Replacement') {
                    imagePath = 'assets/door_handle.png';
                  } else if (serviceName == 'Door Lock Repair') {
                    imagePath = 'assets/door_lock.png';
                  } else if (serviceName == 'Handle Repair') {
                    imagePath = 'assets/door_handle.png';
                  } else if (serviceName == 'Coolant Flush') {
                    imagePath = 'assets/coolant_flush.png';
                  } else if (serviceName == 'Engine Oil Change') {
                    imagePath = 'assets/change_oil.png';
                  } else if (serviceName == 'Spark Plug') {
                    imagePath = 'assets/spark_plug.png';
                  } else if (serviceName == 'Air Filter') {
                    imagePath = 'assets/air_flilter.png';
                  } else if (serviceName == 'Fuel Injector Cleaning') {
                    imagePath = 'assets/fuel_injector.png';
                  } else if (serviceName == 'Timing Belt') {
                    imagePath = 'assets/timing_belt.png';
                  } else if (serviceName == 'Tire Replacement') {
                    imagePath = 'assets/tire.png';
                  } else if (serviceName == 'Wheel Alignment') {
                    imagePath = 'assets/wheel_alignment.png';
                  } else if (serviceName == 'Brake Pad Set') {
                    imagePath = 'assets/brake_pads.png';
                  } else if (serviceName == 'Brake Fluid') {
                    imagePath = 'assets/brake_fluid.png';
                  } else if (serviceName == 'Alternator Repair') {
                    imagePath = 'assets/alternator.png';
                  } else if (serviceName == 'Fuse Replacement') {
                    imagePath = 'assets/fuse.png';
                  } else if (serviceName == 'Car Alarm') {
                    imagePath = 'assets/car_alarm.png';
                  } else if (serviceName == 'Battery Replacement') {
                    imagePath = 'assets/car_battery.png';
                  } else if (serviceName == 'Headlight Bulb') {
                    imagePath = 'assets/headlight_bulb.png';
                  } else if (serviceName == 'Power Window Switch') {
                    imagePath = 'assets/power_window_switch.png';
                  }

                  return ServiceCard(
                    serviceName: serviceName,
                    servicePrice: service['price']!,
                    imagePath: imagePath,
                    isSelected:
                        isSelected, // Global selection state is used here
                    onAddPressed: () => _toggleServiceSelection(serviceName),
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
  final String? imagePath;
  final bool isSelected;
  final VoidCallback onAddPressed;

  const ServiceCard({
    super.key,
    required this.serviceName,
    required this.servicePrice,
    this.imagePath,
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
            if (imagePath != null) // Display the image if imagePath is provided
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(8.0), // Adjust radius as needed
                child: Image.asset(
                  imagePath!,
                  height: 70, // Adjust the height as needed
                  width: 100, // Set the width for the image
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              serviceName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
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
                  size: 25, // Adjust the icon size as needed
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
    if (isEmpty) {
      return '';
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
