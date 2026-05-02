/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _PharmacyListScreenState();
}

class _PharmacyListScreenState extends State<MapScreen> {
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(6.9271, 79.8612), // Colombo coordinates
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pharmacy Map")),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: {
          const Marker(
            markerId: MarkerId("pharmacy1"),
            position: LatLng(6.9271, 79.8612),
            infoWindow: InfoWindow(title: "HealthPlus Pharmacy"),
          ),
        },
      ),
    );
  }
}*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  LatLng _currentPosition = const LatLng(6.9271, 79.8612);

  final Set<Marker> _markers = {};

  final String apiKey = "API key 4"; 

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // 📍 Get user location
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _fetchNearbyPharmacies();
  }

  // 🏥 Google Places API call
  Future<void> _fetchNearbyPharmacies() async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${_currentPosition.latitude},${_currentPosition.longitude}"
        "&radius=3000"
        "&type=pharmacy"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    final data = json.decode(response.body);

    if (data["results"] != null) {
      for (var place in data["results"]) {
        final marker = Marker(
          markerId: MarkerId(place["place_id"]),
          position: LatLng(
            place["geometry"]["location"]["lat"],
            place["geometry"]["location"]["lng"],
          ),
          infoWindow: InfoWindow(
            title: place["name"],
            snippet: place["vicinity"],
          ),
        );

        setState(() {
          _markers.add(marker);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Pharmacies")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}