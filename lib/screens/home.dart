import 'dart:async';

import 'package:aj_autofix/bloc/notifications/Notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/service/selected_services_bloc.dart';
import 'package:aj_autofix/bloc/service/selected_services_event.dart';
import 'package:aj_autofix/bloc/service/selected_services_state.dart';
import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/screens/profile_screen.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:aj_autofix/widgets/service_card.dart';
import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SelectedServicesBloc>(
      create: (context) => SelectedServicesBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
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
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedCategories = {};
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

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
    context.read<NotificationBloc>().fetchNotificationCount();

    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterServices);
    _searchController.dispose();
    _pageController.dispose();
    _timer.cancel();
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
    final bloc = context.read<SelectedServicesBloc>();
    final isSelected = bloc.state.selectedServices.contains(serviceName);

    if (isSelected) {
      bloc.add(RemoveSelectedService(serviceName));
    } else {
      bloc.add(AddSelectedService(serviceName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: kAppBar,
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
              SizedBox(
                height: 100,
                child: Container(
                  decoration: kAppBar,
                  child: const Center(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: kMainColor,
                ),
                title: const Text(
                  'My Profile',
                  style: TextStyle(color: kMainColor),
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
                  color: kMainColor,
                ),
                title: const Text(
                  'Pending',
                  style: TextStyle(color: kMainColor),
                ),
                onTap: () {
                  (context).push("/pendingRequest");
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.contact_mail,
                  color: kMainColor,
                ),
                title: const Text(
                  'Contact Us',
                  style: TextStyle(color: kMainColor),
                ),
                onTap: () {
                  (context).push("/contact");
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.star,
                  color: kMainColor,
                ),
                title: const Text(
                  'Reviews',
                  style: TextStyle(color: kMainColor),
                ),
                onTap: () {
                  (context).push("/reviews");
                },
              ),
              const Divider(),
              ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: kMainColor,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: kMainColor),
                  ),
                  onTap: () async {
                    try {
                      BlocProvider.of<SelectedServicesBloc>(context)
                          .add(ClearSelectedServices());

                      BlocProvider.of<AuthBloc>(context).add(LogoutRequest());
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (context.mounted) {
                        (context).push("/login");
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
                height: 120,
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
                  child: PageView(
                    controller: _pageController,
                    children: [
                      Image.asset(
                        'assets/slide_one.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/slide_two.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/slide_three.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/slide_four.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/slide_five.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    hintText: 'Search for a car service...',
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
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
                child: BlocBuilder<SelectedServicesBloc, SelectedServicesState>(
                  builder: (context, state) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: _filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = _filteredServices[index];
                        final serviceName = service['name']!;
                        final isSelected =
                            state.selectedServices.contains(serviceName);
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
                          onAddPressed: () =>
                              _toggleServiceSelection(serviceName),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
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
                    const Color.fromARGB(255, 147, 191, 198),
                    const Color.fromARGB(255, 110, 136, 161),
                  ]
                : [
                    Colors.grey[300]!,
                    Colors.grey[300]!,
                  ],
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: isSelected ? Colors.white : Colors.black,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
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
