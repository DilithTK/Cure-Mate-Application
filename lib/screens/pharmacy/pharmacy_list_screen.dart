import 'package:flutter/material.dart';
import '../../core/theme/color.dart';
import '../../models/pharmacy_model.dart';
import '../../screens/pharmacy/map_screen.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PharmacyListScreen extends StatefulWidget {
  const PharmacyListScreen({super.key});

  @override
  State<PharmacyListScreen> createState() => _PharmacyListScreenState();
}

class _PharmacyListScreenState extends State<PharmacyListScreen> {

  GoogleMapController? _mapController;
  LatLng? userLocation;

  final List<Map<String, dynamic>> allPharmacies = [
    {
      "name": "CVS Pharmacy",
      "location": const LatLng(6.9271, 79.8612),
    },
    {
      "name": "Walgreens",
      "location": const LatLng(6.9285, 79.8590),
    },
    {
      "name": "HealthPlus",
      "location": const LatLng(6.9300, 79.8650),
    },
  ];

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    // ✅ run AFTER UI loads (no freeze)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserLocation();
    });
  }

  Future<void> _getUserLocation() async {
    try {
      // ✅ Check permission first
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // ❌ user blocked permission
        return;
      }

      // ✅ Get location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userLocation = LatLng(position.latitude, position.longitude);

      _loadNearbyPharmacies();

    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  void _loadNearbyPharmacies() {
    if (userLocation == null) return;

    Set<Marker> nearbyMarkers = {};

    for (var pharmacy in allPharmacies) {
      double distance = Geolocator.distanceBetween(
        userLocation!.latitude,
        userLocation!.longitude,
        pharmacy["location"].latitude,
        pharmacy["location"].longitude,
      );

      if (distance <= 5000) {
        nearbyMarkers.add(
          Marker(
            markerId: MarkerId(pharmacy["name"]),
            position: pharmacy["location"],
            infoWindow: InfoWindow(title: pharmacy["name"]),
          ),
        );
      }
    }

    // ✅ user marker
    nearbyMarkers.add(
      Marker(
        markerId: const MarkerId("me"),
        position: userLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      ),
    );

    setState(() {
      markers = nearbyMarkers;
    });

    // ✅ safe camera move
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(userLocation!, 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: userLocation!,
                zoom: 14,
              ),
              markers: markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
            ),
    );
  }
}
