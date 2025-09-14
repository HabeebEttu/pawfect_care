import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pawfect_care/models/animal_shelter.dart';
import 'package:pawfect_care/models/location.dart' as loc;
import 'package:pawfect_care/services/location_service.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  final Set<Marker> _markers = {};

  final List<AnimalShelter> _animalShelters = [
    AnimalShelter(
      id: '1',
      name: 'Happy Paws Shelter',
      contactPhone: '555-1234',
      contactEmail: 'info@happypaws.com',
      animals: [],
      adoptionRecords: [],
      location: loc.Location(
        address: '123 Main St, Anytown, USA',
        latitude: 37.4223,
        longitude: -122.0848,
      )
    ),
    AnimalShelter(
      id: '2',
      name: 'Furry Friends Rescue',
      contactPhone: '0907864321',
      contactEmail: 'contact@furryfriends.com',
      animals: [],
      adoptionRecords: [],
      location:loc.Location(
        address: '',
        latitude: 37.4223, longitude: -122.0848,
      )
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _setMarkers();
  }

  void _getCurrentLocation() async {
    final locationData = await _locationService.getCurrentLocation();
    if (locationData != null) {
      setState(() {
        _currentLocation = locationData;
      });
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!),
            zoom: 14,
          ),
        ),
      );
    }
  }

  void _setMarkers() {
    for (final shelter in _animalShelters) {
      _markers.add(
        Marker(
          markerId: MarkerId(shelter.id),
          position: LatLng(shelter.location.latitude, shelter.location.longitude),
          infoWindow: InfoWindow(
            title: shelter.name,
            snippet: shelter.location.address,
          ),
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
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _currentLocation != null
              ? LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)
              : const LatLng(37.4223, -122.0848), // Default to GooglePlex
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}