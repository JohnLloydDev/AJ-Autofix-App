import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/repositories/booking_repository_impl.dart';
import 'package:aj_autofix/screens/contact_form.dart';
import 'package:aj_autofix/screens/notification_screen.dart';
import 'package:aj_autofix/screens/profile_screen.dart';
import 'package:aj_autofix/screens/show_reviews_screen.dart';
import 'package:aj_autofix/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:aj_autofix/screens/booking.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:aj_autofix/screens/pendingrequest.dart';
import 'package:aj_autofix/screens/shopmap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  final List<String> selectedServices;
  final int selectedServiceCount;

  const Home({
    super.key,
    required this.selectedServices,
    required this.selectedServiceCount,
  });

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
  int _selectedServiceCount = 0;

  List<Map<String, String>> services = [
    {'name': 'Power Window Motor', 'price': 'PHP 1,500', 'category': 'window'},
    {'name': 'Power Window Cable', 'price': 'PHP 900', 'category': 'window'},
    {'name': 'Powerlock 1pc', 'price': 'PHP 500', 'category': 'window'},
    {'name': 'Powerlock Set', 'price': 'PHP 2,000', 'category': 'window'},
    {'name': 'Door Lock', 'price': 'PHP 550', 'category': 'door'},
    {'name': 'Handle Replacement', 'price': 'PHP 700', 'category': 'door'},
    {'name': 'Door Lock Repair', 'price': 'PHP 400', 'category': 'door'},
    {'name': 'Handle Repair', 'price': 'PHP 500', 'category': 'door'},
    {'name': 'Coolant Flush', 'price': 'PHP 1,200', 'category': 'engine'},
    {'name': 'Engine Change Oil', 'price': 'PHP 1,000', 'category': 'engine'},
    {'name': 'Spark Plug', 'price': 'PHP 800', 'category': 'engine'},
    {'name': 'Air Filter', 'price': 'PHP 600', 'category': 'engine'},
    {
      'name': 'Fuel Injector Cleaning',
      'price': 'PHP 2,200',
      'category': 'engine'
    },
    {'name': 'Timing Belt', 'price': 'PHP 4,500', 'category': 'engine'},
    {'name': 'Tire Replacement', 'price': 'PHP 3,500', 'category': 'wheel'},
    {'name': 'Wheel Alignment', 'price': 'PHP 1,200', 'category': 'wheel'},
    {'name': 'Brake Pad Set', 'price': 'PHP 1,800', 'category': 'wheel'},
    {'name': 'Brake Fluid', 'price': 'PHP 600', 'category': 'wheel'},
    {
      'name': 'Alternator Repair',
      'price': 'PHP 3,500',
      'category': 'electrical'
    },
    {'name': 'Fuse Replacement', 'price': 'PHP 300', 'category': 'electrical'},
    {
      'name': 'Car Alarm',
      'price': 'PHP 1,500 - 1,800',
      'category': 'electrical'
    },
    {
      'name': 'Battery Replacement',
      'price': 'PHP 4,000',
      'category': 'electrical'
    },
    {'name': 'HeadLight Bulb', 'price': 'PHP 500', 'category': 'electrical'},
    {
      'name': 'Power Window Switch',
      'price': 'PHP 1,000',
      'category': 'electrical'
    }
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
          MaterialPageRoute(
            builder: (context) => BookingScreen(
              selectedServices: _selectedServices.toList().cast<String>(),
              selectedServiceCount: _selectedServiceCount,
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopMap(
              selectedServices: _selectedServices.toList(),
              selectedServiceCount: _selectedServiceCount,
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) =>
                  BookingBloc(BookingRepositoryImpl())..add(GetUserBooking()),
              child: NotificationScreen(
                selectedServices: const [],
                selectedServiceCount: _selectedServiceCount,
              ),
            ),
          ),
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
        _selectedServices.remove(serviceName);
        _selectedServiceCount--;
      } else {
        _selectedServices.add(serviceName);
        _selectedServiceCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFDCDCDC),
                Color(0xFF6E88A1),
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Image.asset(
                'assets/home_logo.png',
                height: 40,
                fit: BoxFit.contain,
              ),
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
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFDCDCDC),
                      Color(0xFF6E88A1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
              leading: const Icon(
                Icons.person,
                color: Color(0xFF6E88A1),
              ),
              title: const Text(
                'My Profile',
                style: TextStyle(color: Color(0xFF6E88A1)),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen(
                              userId: '',
                            )));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.pending,
                color: Color(0xFF6E88A1),
              ),
              title: const Text(
                'Pending',
                style: TextStyle(color: Color(0xFF6E88A1)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => BookingBloc(BookingRepositoryImpl())
                        ..add(GetUserBooking()),
                      child: const UserPendingRequest(),
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.contact_mail,
                color: Color(0xFF6E88A1),
              ),
              title: const Text(
                'Contact Us',
                style: TextStyle(color: Color(0xFF6E88A1)),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactFormPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.star,
                color: Color(0xFF6E88A1),
              ),
              title: const Text(
                'Reviews',
                style: TextStyle(color: Color(0xFF6E88A1)),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ShowReviewsScreen()));
              },
            ),
            const Divider(),
            ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Color(0xFF6E88A1),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Color(0xFF6E88A1)),
                ),
                onTap: () async {
                  try {
                    BlocProvider.of<AuthBloc>(context).add(LogoutRequest());
                    await Future.delayed(const Duration(milliseconds: 300));
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout failed: $e')),
                      );
                    }
                  }
                }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5.0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
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
                  final isSelected = _selectedServices.contains(serviceName);
                  String? imagePath;

                  switch (serviceName) {
                    case 'Power Window Motor':
                      imagePath = 'assets/motor.png';
                      break;
                    case 'Power Window Cable':
                      imagePath = 'assets/cable.png';
                      break;
                    case 'Powerlock 1pc':
                      imagePath = 'assets/power_lock_1pc.jpg';
                      break;
                    case 'Powerlock Set':
                      imagePath = 'assets/power_lock_set.png';
                      break;
                    case 'Door Lock':
                      imagePath = 'assets/door_lock.png';
                      break;
                    case 'Handle Replacement':
                    case 'Handle Repair':
                      imagePath = 'assets/door_handle.png';
                      break;
                    case 'Door Lock Repair':
                      imagePath = 'assets/door_lock.png';
                      break;
                    case 'Coolant Flush':
                      imagePath = 'assets/coolant_flush.png';
                      break;
                    case 'Engine Change Oil':
                      imagePath = 'assets/change_oil.png';
                      break;
                    case 'Spark Plug':
                      imagePath = 'assets/spark_plug.png';
                      break;
                    case 'Air Filter':
                      imagePath = 'assets/air_flilter.png';
                      break;
                    case 'Fuel Injector Cleaning':
                      imagePath = 'assets/fuel_injector.png';
                      break;
                    case 'Timing Belt':
                      imagePath = 'assets/timing_belt.png';
                      break;
                    case 'Tire Replacement':
                      imagePath = 'assets/tire.png';
                      break;
                    case 'Wheel Alignment':
                      imagePath = 'assets/wheel_alignment.png';
                      break;
                    case 'Brake Pad Set':
                      imagePath = 'assets/brake_pads.png';
                      break;
                    case 'Brake Fluid':
                      imagePath = 'assets/brake_fluid.png';
                      break;
                    case 'Alternator Repair':
                      imagePath = 'assets/alternator.png';
                      break;
                    case 'Fuse Replacement':
                      imagePath = 'assets/fuse.png';
                      break;
                    case 'Car Alarm':
                      imagePath = 'assets/car_alarm.png';
                      break;
                    case 'Battery Replacement':
                      imagePath = 'assets/car_battery.png';
                      break;
                    case 'HeadLight Bulb':
                      imagePath = 'assets/headlight_bulb.png';
                      break;
                    case 'Power Window Switch':
                      imagePath = 'assets/power_window_switch.png';
                      break;
                    default:
                      imagePath = null;
                  }

                  return ServiceCard(
                    serviceName: serviceName,
                    servicePrice: service['price']!,
                    imagePath: imagePath,
                    isSelected: isSelected,
                    onAddPressed: () => _toggleServiceSelection(serviceName),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6E88A1),
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.receipt),
                if (_selectedServiceCount > 0)
                  Positioned(
                    right: 0,
                    top: -1,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Center(
                        child: Text(
                          '$_selectedServiceCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Booking',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _categoryTextButton(String category) {
    bool isSelected;
    if (category.toLowerCase() == 'all') {
      isSelected = _selectedCategories.isEmpty;
    } else {
      isSelected = _selectedCategories.contains(category.toLowerCase());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isSelected
                ? [
                    const Color.fromARGB(255, 221, 221, 221),
                    const Color.fromARGB(255, 110, 136, 161),
                  ]
                : [
                    Colors.grey[300]!,
                    Colors.grey[300]!,
                  ],
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: isSelected ? Colors.white : Colors.black,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {
            _onCategorySelected(category.toLowerCase());
          },
          child: Text(category.capitalize()),
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
