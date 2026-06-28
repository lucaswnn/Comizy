import 'package:comizy/services/change_notifiers/async_action_notifier.dart';
import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/command/set_location_command.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/widgets/async_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class SetLocationMapPage extends StatefulWidget {
  const SetLocationMapPage({super.key});

  @override
  State<SetLocationMapPage> createState() => _SetLocationMapPageState();
}

class _SetLocationMapPageState extends State<SetLocationMapPage> {
  late final MapController _mapController;
  LatLng? _settedLocation;
  LatLng? _currentLocation;
  LatLng _initialCenter = LocationNotifier.defaultLocation;
  double _initialZoom = 6;

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
    final locationNotifier = context.read<LocationNotifier>();
    _settedLocation = locationNotifier.settedLocation;
    _currentLocation = locationNotifier.currentLocation;
    if (_currentLocation != null) {
      _initialCenter = _currentLocation!;
      _initialZoom = 14;
    } else if (_settedLocation != null) {
      _initialCenter = _settedLocation!;
      _initialZoom = 14;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = [
      if (_settedLocation != null)
        Marker(
          point: _settedLocation!,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_pin,
            color: Colors.green,
            size: 40,
          ),
        ),
      if (_currentLocation != null)
        Marker(
          point: _currentLocation!,
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
                    initialCenter: _initialCenter,
                    initialZoom: _initialZoom,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.comizy.app',
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
          ChangeNotifierProvider(
            create: (_) => AsyncActionNotifier<SetCustomLocationResult>(),
            child: Consumer<AsyncActionNotifier<SetCustomLocationResult>>(
              builder: (context, asyncActionNotifier, _) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    switch (asyncActionNotifier.result) {
                      case SetCustomLocationResult.success:
                        NavigationHelper.pushNamedAndClearStack(
                            AppRoutes.mainPage);
                        break;
                      default:
                        break;
                    }
                  },
                );

                final locationNotifier = context.read<LocationNotifier>();
                final helpRequestNotifier = context.read<HelpRequestNotifier>();
                return AsyncElevatedButton(
                  notifier: asyncActionNotifier,
                  command: SetCustomLocationCommand(
                    locationNotifier: locationNotifier,
                    helpRequestNotifier: helpRequestNotifier,
                    getLatLngFunc: () => _mapController.camera.center,
                  ),
                  child: const Text('Definir localização'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
