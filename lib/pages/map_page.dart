import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:pawfect_care/models/animal_shelter.dart';
import 'package:pawfect_care/models/location.dart' as loc;
import 'package:pawfect_care/services/location_service.dart';
import 'package:pawfect_care/providers/shelter_provider.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LocationService _locationService = LocationService();
  MapController? _mapController;
  LocationData? _currentLocation;
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShelterProvider>(context, listen: false).fetchAllShelters();
    });
  }

  void _getCurrentLocation() async {
    final locationData = await _locationService.getCurrentLocation();
    if (locationData != null) {
      setState(() {
        _currentLocation = locationData;
      });
      _mapController?.move(
        LatLng(locationData.latitude!, locationData.longitude!),
        14,
      );
    }
  }

  void _setMarkers(List<AnimalShelter> shelters) {
    _markers.clear(); // Clear existing markers
    for (final shelter in shelters) {
      _markers.add(
        Marker(
          point: LatLng(shelter.location.latitude, shelter.location.longitude),
          width: 80,
          height: 80,
          child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Shelters'),
      ),
      body: Consumer<ShelterProvider>(
        builder: (context, shelterProvider, child) {
          if (shelterProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          _setMarkers(shelterProvider.allShelters); // Update markers when shelters change

          return FlutterMap(
            options: MapOptions(
              center: _currentLocation != null
                  ? LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)
                  : const LatLng(37.4223, -122.0848), // Default to GooglePlex
              zoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          );
        },
      ),
    );
  }
}
