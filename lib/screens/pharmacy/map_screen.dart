import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _defaultCenter = LatLng(6.9271, 79.8612);

  GoogleMapController? mapController;
  LatLng _currentPosition = _defaultCenter;
  bool hasUserLocation = false;
  final Set<Marker> _markers = {};
  bool isLoading = true;
  String? message;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      await _getCurrentLocation();
      await _loadRegisteredPharmacies();
    } catch (e) {
      debugPrint("Map error: $e");
      await _loadRegisteredPharmacies(
        "Could not get your current location. Showing registered pharmacies only.",
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location permission denied.");
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );

    _currentPosition = LatLng(
      position.latitude,
      position.longitude,
    );
    hasUserLocation = true;
  }

  Future<void> _loadRegisteredPharmacies([String? fallbackMessage]) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('pharmacies').get();

    _markers.clear();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final pharmacyLocation = _readPharmacyLocation(data);

      if (pharmacyLocation == null) {
        continue;
      }

      final distance = Geolocator.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        pharmacyLocation.latitude,
        pharmacyLocation.longitude,
      );

      if (!hasUserLocation || distance <= 5000) {
        _markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: pharmacyLocation,
            infoWindow: InfoWindow(
              title: data['name']?.toString() ?? 'Pharmacy',
              snippet: hasUserLocation
                  ? "${distance.toStringAsFixed(0)} m away"
                  : null,
            ),
          ),
        );
      }
    }

    if (hasUserLocation) {
      _markers.add(
        Marker(
          markerId: const MarkerId("me"),
          position: _currentPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
          infoWindow: const InfoWindow(title: "You are here"),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
      message = fallbackMessage ??
          (_markers.isEmpty || (hasUserLocation && _markers.length == 1)
              ? "No registered pharmacies found within 5 km."
              : null);
    });
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
      appBar: AppBar(
        title: const Text("Nearby Pharmacies"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 15,
        ),
        markers: _markers,
        myLocationEnabled: hasUserLocation,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) {
          mapController = controller;
          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(_currentPosition, 15),
          );
        },
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
