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
<<<<<<< HEAD
=======
/*import 'package:flutter/material.dart';

class SelectPharmacyScreen extends StatelessWidget {
  const SelectPharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Cure Mate",
            style: TextStyle(color: Colors.black)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Pharmacy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "We found 5 pharmacies near you based on your prescription.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  pharmacyCard(
                    name: "CVS Pharmacy",
                    distance: "0.8 miles",
                    status: "Available",
                    statusColor: Colors.green,
                  ),
                  pharmacyCard(
                    name: "Walgreens",
                    distance: "1.2 miles",
                    status: "Waiting Response",
                    statusColor: Colors.orange,
                  ),
                  pharmacyCard(
                    name: "Rite Aid",
                    distance: "1.5 miles",
                    status: "Partial Stock",
                    statusColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pharmacyCard({
    required String name,
    required String distance,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(distance, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status,
                style: TextStyle(color: statusColor, fontSize: 12)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.call),
                onPressed: () {},
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Select ✓"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}*/
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
