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

  LatLng? _currentPosition;

  final Set<Marker> _markers = {};

<<<<<<< HEAD
  
=======
  // 🔑 Replace with your real API key
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  final String apiKey = "API key 4";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

<<<<<<< HEAD

=======
  // 🚀 Initialize
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    await _fetchNearbyPharmaciesSmart();

    setState(() {
      isLoading = false;
    });
  }

<<<<<<< HEAD
  
=======
  // 📍 Get current location
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

<<<<<<< HEAD
    
=======
    // Location ON check
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

<<<<<<< HEAD
    
=======
    // Permission check
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied.");
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _currentPosition = LatLng(
      position.latitude,
      position.longitude,
    );
  }

<<<<<<< HEAD
  
=======
  // 🏥 Smart radius search
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Future<void> _fetchNearbyPharmaciesSmart() async {
    List<int> radiusList = [500, 1000, 3000];

    for (int radius in radiusList) {
      final url =
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
          "?location=${_currentPosition!.latitude},${_currentPosition!.longitude}"
          "&radius=$radius"
          "&type=pharmacy"
          "&key=$apiKey";

      final response = await http.get(Uri.parse(url));

      final data = json.decode(response.body);

      if (data["results"] != null &&
          data["results"].length > 0) {

        _markers.clear();

        for (var place in data["results"]) {

          final double lat =
              place["geometry"]["location"]["lat"];

          final double lng =
              place["geometry"]["location"]["lng"];

<<<<<<< HEAD
          
=======
          // 📏 Distance calculate
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
          double distance =
              Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            lat,
            lng,
          );

          final marker = Marker(
            markerId: MarkerId(place["place_id"]),

            position: LatLng(lat, lng),

            infoWindow: InfoWindow(
              title: place["name"],
              snippet:
                  "${place["vicinity"]}\n${distance.toStringAsFixed(0)}m away",
            ),

            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          );

          _markers.add(marker);
        }

        setState(() {});

        print("Found pharmacies within ${radius}m");

        return;
      }
    }

<<<<<<< HEAD
   
=======
    // ❌ No pharmacies found
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No pharmacies found nearby"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // ⏳ Loading
    if (isLoading || _currentPosition == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Pharmacies"),
      ),

      body: GoogleMap(

        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 15,
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