import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PharmacyListScreen extends StatefulWidget {
  const PharmacyListScreen({super.key});

  @override
  State<PharmacyListScreen> createState() => _PharmacyListScreenState();
}

class _PharmacyListScreenState extends State<PharmacyListScreen> {
  static const LatLng _defaultCenter = LatLng(6.9271, 79.8612);

  GoogleMapController? _mapController;
  LatLng userLocation = _defaultCenter;
  bool hasUserLocation = false;
  Set<Marker> markers = {};
  bool isLoading = true;
  String? message;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserLocation();
    });
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        await _loadNearbyPharmacies(
          "Location permission is required to sort pharmacies by distance.",
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        await _loadNearbyPharmacies(
          "Location permission is blocked. Showing registered pharmacies only.",
        );
        return;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _loadNearbyPharmacies(
          "Location services are off. Showing registered pharmacies only.",
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      userLocation = LatLng(position.latitude, position.longitude);
      hasUserLocation = true;

      await _loadNearbyPharmacies();
    } catch (e) {
      debugPrint("Location error: $e");
      await _loadNearbyPharmacies(
        "Could not get your current location. Showing registered pharmacies only.",
      );
    }
  }

  Future<void> _loadNearbyPharmacies([String? fallbackMessage]) async {
    final nearbyMarkers = <Marker>{};
    final snapshot =
        await FirebaseFirestore.instance.collection('pharmacies').get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final pharmacyLocation = _readPharmacyLocation(data);

      if (pharmacyLocation == null) {
        continue;
      }

      final distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        pharmacyLocation.latitude,
        pharmacyLocation.longitude,
      );

      if (!hasUserLocation || distance <= 5000) {
        final name = data['name']?.toString() ?? 'Pharmacy';

        nearbyMarkers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: pharmacyLocation,
            infoWindow: InfoWindow(
              title: name,
              snippet: hasUserLocation
                  ? "${distance.toStringAsFixed(0)} m away"
                  : null,
            ),
          ),
        );
      }
    }

    if (hasUserLocation) {
      nearbyMarkers.add(
        Marker(
          markerId: const MarkerId("me"),
          position: userLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
          infoWindow: const InfoWindow(title: "You are here"),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      markers = nearbyMarkers;
      isLoading = false;
      message = fallbackMessage ??
          (nearbyMarkers.isEmpty ||
                  (hasUserLocation && nearbyMarkers.length == 1)
          ? "No registered pharmacies found within 5 km."
          : null);
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(userLocation, 14),
    );
  }

  LatLng? _readPharmacyLocation(Map<String, dynamic> data) {
    final position = data['position'];
    if (position is GeoPoint) {
      return LatLng(position.latitude, position.longitude);
    }

    final latitude = data['latitude'];
    final longitude = data['longitude'];
    if (latitude is num && longitude is num) {
      return LatLng(latitude.toDouble(), longitude.toDouble());
    }

    final location = data['location'];
    if (location is Map) {
      final lat = location['lat'];
      final lng = location['lng'];

      if (lat is num && lng is num) {
        return LatLng(lat.toDouble(), lng.toDouble());
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userLocation,
          zoom: 14,
        ),
        markers: markers,
        onMapCreated: (controller) {
          _mapController = controller;
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(userLocation, 14),
          );
        },
        myLocationEnabled: hasUserLocation,
        myLocationButtonEnabled: true,
      ),
      bottomNavigationBar: message == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
    );
  }
}
