import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'models.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'wmata_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WMATA Live',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const BusStopMapPage(),
    );
  }
}

// Use BusStop from models.dart

class BusStopMapPage extends StatefulWidget {
  const BusStopMapPage({super.key});

  @override
  State<BusStopMapPage> createState() => _BusStopMapPageState();
}

class _BusStopMapPageState extends State<BusStopMapPage> {
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _userLocation;
  List<BusStop> _stops = [];

  Future<void> _getLocationAndStops() async {
    // Request location permission and get user location
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
      return;
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
    if (!mounted) return;
    final userLoc = LatLng(position.latitude, position.longitude);
    List<BusStop> stops = [];
    try {
      stops = await WmataApi().getNearbyStops(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to fetch stops: $e')));
    }
    if (!mounted) return;
    setState(() {
      _userLocation = userLoc;
      _stops = stops;
    });
    final controller = await _mapController.future;
    if (!mounted) return;
    controller.animateCamera(CameraUpdate.newLatLng(userLoc));
  }

  void _onMarkerTapped(BusStop stop) async {
    if (!mounted) return;
    List<NextBusPrediction> predictions = [];
    try {
      predictions = await WmataApi().getNextBusPredictions(stop.stopId);
    } catch (_) {}
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => _buildStopDetails(stop, predictions),
    );
  }

  Widget _buildStopDetails(BusStop stop, List<NextBusPrediction> predictions) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stop.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (predictions.isEmpty)
              const Text('No upcoming arrivals found.')
            else
              ...predictions.map<Widget>(
                (prediction) => ListTile(
                  leading: const Icon(Icons.directions_bus),
                  title: Text(prediction.routeId),
                  subtitle: Text(
                    '${prediction.directionText}\nArriving in ${prediction.minutes} min',
                  ),
                  trailing: Text('Bus ${prediction.vehicleId}'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WMATA Bus ETA')),
      body: _userLocation == null
          ? Center(child: Text('Tap the button to find nearby stops'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _userLocation!,
                zoom: 15,
              ),
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              markers: _stops
                  .map(
                    (stop) => Marker(
                      markerId: MarkerId(stop.stopId),
                      position: LatLng(stop.lat, stop.lon),
                      infoWindow: InfoWindow(title: stop.name),
                      onTap: () => _onMarkerTapped(stop),
                    ),
                  )
                  .toSet(),
              onMapCreated: (controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocationAndStops,
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
