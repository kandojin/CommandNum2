import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  BitmapDescriptor? _userIcon;
  LatLng? _userPosition;

  final LatLng _initialPosition = LatLng(49.8061, 73.0869);

  final List<Map<String, dynamic>> _policeStations = [
    {
      "name": "Local police station 13",
      "position": LatLng(49.7915373, 73.1493341),
    },
    {
      "name": "Local police station 2",
      "position": LatLng(49.8224611, 73.1056120),
    },
    {"name": "Police stronghold", "position": LatLng(49.8066530, 73.1369757)},
    {
      "name": "Mikhail Police Department",
      "position": LatLng(49.8112279, 73.0667572),
    },
    {
      "name": "RED of traffic polie",
      "position": LatLng(49.7732598, 73.1241363),
    },
    {
      "name": "Central Police Department",
      "position": LatLng(49.8189501, 73.1087371),
    },
    {
      "name": "Oktyabrsky Police Department",
      "position": LatLng(49.8791409, 73.1837323),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserIcon();
  }

  // Load Custom Icon for User Location
  void _loadUserIcon() async {
    _userIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)), // Adjust size as needed
      "assets/user_marker.png", // Place this file in `assets/` folder
    );
    setState(() {});
  }

  // Get User Location
  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Move Camera & Add Custom Marker for User Location
  void _moveToUserLocation() async {
    try {
      Position position = await _getUserLocation();
      LatLng newPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        _userPosition = newPosition;
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newPosition, 14.0),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // Generate Markers
  Set<Marker> _createMarkers() {
    Set<Marker> markers =
        _policeStations.map((station) {
          return Marker(
            markerId: MarkerId(station["name"]),
            position: station["position"],
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(title: station["name"]),
          );
        }).toSet();

    // Add User Marker
    if (_userPosition != null && _userIcon != null) {
      markers.add(
        Marker(
          markerId: MarkerId("user_location"),
          position: _userPosition!,
          icon: _userIcon!,
          infoWindow: InfoWindow(title: "You are here"),
        ),
      );
    }

    return markers;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Qorgau - Karaganda")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12.0,
        ),
        markers: _createMarkers(),
        myLocationEnabled: false, // Disable default blue dot
        myLocationButtonEnabled: false, // Custom button instead
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveToUserLocation,
        child: Icon(Icons.my_location),
        backgroundColor: const Color.fromARGB(255, 27, 78, 136),
      ),
    );
  }
}
