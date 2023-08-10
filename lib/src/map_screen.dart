import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData? _currentLocation;
  final List<Marker> _currentMarker = [];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final location = Location();
    try {
      _currentLocation = await location.getLocation();
      if (_currentLocation != null) {
        _currentMarker.add(
          Marker(
            width: 40.0,
            height: 40.0,
            point: LatLng(
                _currentLocation!.latitude!, _currentLocation!.longitude!),
            builder: (context) => const Icon(
              Icons.location_on,
              color: Colors.blue,
            ),
          ),
        );
        _mapController.move(
          LatLng(
            _currentLocation!.latitude!,
            _currentLocation!.longitude!,
          ),
          13.0,
        );
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        maxZoom: 17.7,
        keepAlive: true,
        center: const LatLng(0, 0),
        zoom: 13,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          showFlutterMapAttribution: false,
          attributions: [
            TextSourceAttribution(
              'testando',
              prependCopyright: false,
              onTap: () {},
            ),
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.comizy.comizy',
        ),
        MarkerLayer(
          markers: _currentMarker,
        ),
      ],
    );
  }
}
