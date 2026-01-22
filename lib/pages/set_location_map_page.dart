import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class SetLocationMapPage extends StatelessWidget {
  SetLocationMapPage({super.key});

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final locationNotifier = context.read<LocationNotifier>();
    final settedLocation = locationNotifier.settedLocation;
    final currentLocation = locationNotifier.currentLocation;
    LatLng initialCenter = LocationNotifier.defaultLocation;
    double initialZoom = 6;
    if (currentLocation != null) {
      initialCenter = currentLocation;
      initialZoom = 14;
    } else if (settedLocation != null) {
      initialCenter = settedLocation;
      initialZoom = 14;
    }

    final markers = [
      if (settedLocation != null)
        Marker(
          point: settedLocation,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_pin,
            color: Colors.green,
            size: 40,
          ),
        ),
      if (currentLocation != null)
        Marker(
          point: currentLocation,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 40,
          ),
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione sua localização'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: initialCenter,
                    initialZoom: initialZoom,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: markers,
                    ),
                  ],
                ),
                const Center(
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              locationNotifier.setCustomLocation(_mapController.camera.center);
              NavigationHelper.pushReplacementNamed(AppRoutes.mainPage);
            },
            child: const Text('Definir localização'),
          ),
        ],
      ),
    );
  }
}
