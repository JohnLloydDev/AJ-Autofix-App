import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home.dart';
import 'booking.dart';

class ShopMap extends StatefulWidget {
  const ShopMap({super.key});

  @override
  ShopMapState createState() => ShopMapState();
}

class ShopMapState extends State<ShopMap> {
  int _selectedIndex = 2;
  final LatLng shopLocation = const LatLng(16.0884245, 120.3917141); 
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    
    // Adding a delay to ensure map initialization
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('shopLocation'),
            position: shopLocation,
            infoWindow: const InfoWindow(
              title: 'A & J Autofix',
              snippet: 'Your trusted car shop',
            ),
          ),
        );
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
        break;
      case 1:
        List<String> selectedServices = ['Oil Change', 'Tire Rotation'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(
              selectedServices: selectedServices,
            ),
          ),
        );
        break;
      case 2:
        break; 
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text('Shop Location'),
        backgroundColor: Colors.lightBlue,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: shopLocation,
          zoom: 15,
        ),
        markers: _markers,
        mapType: MapType.normal, 
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

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
