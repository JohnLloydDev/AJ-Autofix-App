import 'package:aj_autofix/bloc/notifications/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aj_autofix/bloc/notifications/Notification_bloc.dart';
import 'package:url_launcher/url_launcher.dart';  // Import for launching URLs
import 'home.dart';
import 'booking_screen.dart';
import 'notification_screen.dart';

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
    context.read<NotificationBloc>().fetchNotificationCount();

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
            onTap: _launchMapsUrl,  // Launch maps on marker tap
          ),
        );
      });
    });
  }

  Future<void> _launchMapsUrl() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${shopLocation.latitude},${shopLocation.longitude}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
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
            builder: (context) => const HomeScreen(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BookingScreen(),
          ),
        );
        break;
      case 2:
        break;
      case 3:
        context.read<NotificationBloc>().resetNotificationCount();
        context.read<NotificationBloc>().fetchNotificationCount();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: context.read<NotificationBloc>(),
              child: NotificationScreen(
                selectedServices: widget.selectedServices,
                selectedServiceCount: widget.selectedServiceCount,
              ),
            ),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('Shop Location'),
        backgroundColor: Colors.lightBlue,
      ),
      body: GoogleMap(
        
        initialCameraPosition: CameraPosition(
          target: shopLocation,
          zoom: 15,
        ),
        myLocationButtonEnabled: false,
        markers: _markers,
        mapType: MapType.normal,
        onMapCreated: _onMapCreated, 
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
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationLoading) {
                      return Positioned(
                        right: 0,
                        top: -1,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 15,
                            minHeight: 15,
                          ),
                        ),
                      );
                    } else if (state is NotificationLoaded &&
                        state.notificationCount > 0) {
                      return Positioned(
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
                              '${state.notificationCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }
                    return Positioned(
                      right: 0,
                      top: -1,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            label: 'Notification',
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