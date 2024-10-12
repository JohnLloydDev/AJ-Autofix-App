import 'package:aj_autofix/bloc/notifications/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aj_autofix/bloc/notifications/Notification_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home.dart';
import 'booking_screen.dart';
import 'notification_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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
  Position? _currentPosition;
  Stream<Position>? _positionStream;
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().fetchNotificationCount();
    _initLocationService();
    _addShopMarker();
  }

  Future<void> _initLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationServiceDialog();
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _showPermissionDeniedDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _showPermissionDeniedForeverDialog();
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _updateUserMarker(_currentPosition!);
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 10),
    );
    _positionStream?.listen((Position position) {
      setState(() {
        _currentPosition = position;
        _updateUserMarker(position);
        _moveCamera(position);
      });
    });
  }

  Future<void> _showLocationServiceDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content:
            const Text('Please enable location services to use this feature.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openLocationSettings();
              _initLocationService();
            },
            child: const Text('Enable'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _showPermissionDeniedDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Denied'),
        content: const Text(
            'Location permissions are denied. Please allow location access to use this feature.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.requestPermission();
              _initLocationService();
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _showPermissionDeniedForeverDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Permanently Denied'),
        content: const Text(
            'Location permissions are permanently denied. Please enable them from the app settings.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _addShopMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('shopLocation'),
        position: shopLocation,
        infoWindow: const InfoWindow(
          title: 'A & J Autofix',
          snippet: 'Your trusted car shop',
        ),
        onTap: _launchMapsUrl,
      ),
    );
    setState(() {});
  }

  void _updateUserMarker(Position position) {
    final userMarker = Marker(
      markerId: const MarkerId('userLocation'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: const InfoWindow(
        title: 'Your Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'userLocation');
      _markers.add(userMarker);
    });
  }

  Future<void> _launchMapsUrl() async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${shopLocation.latitude},${shopLocation.longitude}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  void _moveCamera(Position position) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ),
    );
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

  void _drawRouteToShop() {
    if (_currentPosition != null) {
      const polylineId = PolylineId('routeToShop');
      final newPolyline = Polyline(
        polylineId: polylineId,
        visible: true,
        points: [
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          shopLocation,
        ],
        color: Colors.blue,
        width: 5,
      );
      setState(() {
        _polylines.add(newPolyline);
      });
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
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: shopLocation,
              zoom: 15,
            ),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentPosition != null) {
                  _drawRouteToShop();
                  _moveCamera(_currentPosition!);
                }
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.directions),
            ),
          ),
        ],
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
}
