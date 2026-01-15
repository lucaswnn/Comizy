import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class SetLocationMapPage extends StatefulWidget {
  const SetLocationMapPage({super.key});

  @override
  State<SetLocationMapPage> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<SetLocationMapPage> {
  final MapController _mapController = MapController();
  LatLng _desiredLocation = LocationNotifier.defaultLocation;

  @override
  Widget build(BuildContext context) {
    final locationNotifier = context.read<LocationNotifier>();
    final settedLocation = locationNotifier.settedLocation;
    final readedLocation = locationNotifier.currentLocation;
    var currentLocation = readedLocation;
    double initialZoom = 16;
    if (currentLocation == null) {
      currentLocation = LocationNotifier.defaultLocation;
      initialZoom = 6;
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
      if (readedLocation != null)
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
                    initialCenter: currentLocation,
                    initialZoom: initialZoom,
                    onPositionChanged: (camera, hasGesture) {
                      if (hasGesture) {
                        setState(() => _desiredLocation = camera.center);
                      }
                    },
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
              locationNotifier.setCustomLocation(_desiredLocation);
              NavigationHelper.popUntilNamed(AppRoutes.mainPage);
            },
            child: const Text('Definir localização'),
          ),
        ],
      ),
    );
  }
}
