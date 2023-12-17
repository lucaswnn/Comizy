import 'package:comizy/src/state/state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData? _currentLocation;
  final List<Marker> _markers = [];
  final List<CircleMarker> _circleMarkers = [];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _firstSetup();
  }

  Future<void> _firstSetup() async {
    final loc = Location();
    try {
      _currentLocation = await loc.getLocation();
      _setup();
    } catch (e) {
      print('erro_comizy: $e');
    }
  }

  void _setup() {
    if (_currentLocation != null) {
      _markers.add(
        Marker(
          width: 40.0,
          height: 40.0,
          point:
              LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          builder: (context) => const Icon(
            Icons.circle,
            size: 15,
            shadows: [
              Shadow(
                color: Colors.blueAccent,
                blurRadius: 6,
              )
            ],
            color: Colors.blue,
          ),
        ),
      );

      _circleMarkers.add(CircleMarker(
        point:
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        radius: _currentLocation!.accuracy! == 0
            ? 500
            : _currentLocation!.accuracy!,
        useRadiusInMeter: true,
        borderColor: Colors.lightBlue,
        borderStrokeWidth: 3,
        color: const Color.fromARGB(24, 0, 204, 255),
      ));

      var testData = context.read<MyAppState>().testData;
      testData.loadLocations(LatLng(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
      ));
      for (var shop in testData.shops) {
        _markers.add(
          Marker(
            width: 30,
            height: 30,
            anchorPos: AnchorPos.align(AnchorAlign.center),
            point: shop.location,
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.location_on_sharp,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 2,
                  ),
                ],
                color: Colors.yellow,
              ),
              iconSize: 30,
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              onPressed: () => print('aqui'),
            ),
          ),
        );
      }

      _mapController.move(
        LatLng(
          _currentLocation!.latitude!,
          _currentLocation!.longitude!,
        ),
        13.0,
      );
    } else {
      print('erro_comizy_setup_map');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
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
              'OpenStreetMap',
              prependCopyright: true,
              onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
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
        CircleLayer(
          circles: _circleMarkers,
        ),
        MarkerLayer(
          markers: _markers,
        ),
      ],
    );
  }
}
