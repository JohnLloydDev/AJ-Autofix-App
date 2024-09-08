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

  final LatLng shopLocation = const LatLng(13.794185, 122.473262);

  // Google Maps controller
  GoogleMapController? _mapController;

  // Marker to be displayed at the shop location
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: const MarkerId('shopLocation'),
        position: shopLocation,
        infoWindow: const InfoWindow(
          title: 'E & J Autofix',
          snippet: 'Your trusted car shop',
        ),
      ),
    );
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Booking()),
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
        title: const Text('Shop Location'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.directions),
            onPressed: () {
              // Optionally add functionality for directions here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Directions Button Pressed')),
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: shopLocation,
          zoom: 15, // Set zoom level
        ),
        markers: _markers, // Display marker at shop location
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
