import 'dart:convert';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ShopMap extends StatefulWidget {
  const ShopMap({
    super.key,
  });

  @override
  ShopMapState createState() => ShopMapState();
}

class ShopMapState extends State<ShopMap> {
  final LatLng shopLocation = const LatLng(16.0885986, 120.3918851);
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Position? _currentPosition;
  Stream<Position>? _positionStream;
  StreamSubscription<Position>? _positionStreamSubscription;
  final Set<Polyline> _polylines = {};

  final String _googleMapsApiKey = 'AIzaSyAS0R3NQrhIfMVXvuBIraWdGVBa7ct96-k';

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(GetNewUserBookingCount());
    _initLocationService();
    _addShopMarker();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
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
    if (mounted) {
      _updateUserMarker(_currentPosition!);
    }
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 10),
    );
    _positionStreamSubscription = _positionStream?.listen((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _updateUserMarker(position);
          _moveCamera(position);
        });
      }
    });
  }

  Future<void> _showLocationServiceDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kWhiteColor, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text(
          'Location Services Disabled',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          'Please enable location services to use this feature.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openLocationSettings();
              _initLocationService();
            },
            child: const Text(
              'Enable',
              style: TextStyle(
                color: kBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
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

    if (mounted) {
      setState(() {
        _markers
            .removeWhere((marker) => marker.markerId.value == 'userLocation');
        _markers.add(userMarker);
      });
    }
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

  Future<List<LatLng>> _fetchRoute() async {
    if (_currentPosition == null) return [];

    final origin =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final destination = '${shopLocation.latitude},${shopLocation.longitude}';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$_googleMapsApiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch directions');
    }

    final data = json.decode(response.body);
    if ((data['routes'] as List).isEmpty) {
      throw Exception('No routes found');
    }

    final points = data['routes'][0]['overview_polyline']['points'];
    return _decodePolyline(points);
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  void _drawRouteToShop() async {
    if (_currentPosition != null) {
      try {
        List<LatLng> route = await _fetchRoute();
        const polylineId = PolylineId('routeToShop');
        final newPolyline = Polyline(
          polylineId: polylineId,
          visible: true,
          points: route,
          color: Colors.blue,
          width: 5,
        );
        if (mounted) {
          setState(() {
            _polylines.add(newPolyline);
          });
        }
      } catch (e) {
        // Handle error or show a message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Container(
          decoration: kAppBar,
        ),
        title: const Text(
          'Shop Location',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: shopLocation,
              zoom: 15,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 120,
            right: 20,
            child: FloatingActionButton(
              onPressed: _drawRouteToShop,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              child: const Icon(
                Icons.directions,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
