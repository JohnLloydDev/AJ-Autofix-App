import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home.dart';
import 'booking.dart';

class ShopMap extends StatefulWidget {
  final List<String> selectedServices;
  final int selectedServiceCount;

  const ShopMap({
    super.key,
    required this.selectedServices,
    required this.selectedServiceCount,
  });
  @override
  ShopMapState createState() => ShopMapState();
}

class ShopMapState extends State<ShopMap> {
  int _selectedIndex = 2;
  final LatLng shopLocation = const LatLng(16.0885986, 120.3918851);
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              selectedServices:
                  widget.selectedServices,
              selectedServiceCount: widget
                  .selectedServiceCount,
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BookingScreen(
              selectedServices: [],
              selectedServiceCount: 0,
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
  items: [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Stack(
        children: [
          const Icon(Icons.receipt),
          if (widget.selectedServiceCount > 0)
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
                    '${widget.selectedServiceCount}',
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
