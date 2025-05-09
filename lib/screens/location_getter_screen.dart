import 'package:comizy/utils/snackbar_helper.dart';
import 'package:comizy/values/app_general_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

class LocationGetterScreen extends StatefulWidget {
  const LocationGetterScreen({super.key});

  @override
  State<LocationGetterScreen> createState() => _LocationGetterScreenState();
}

class _LocationGetterScreenState extends State<LocationGetterScreen> {
  final LatLng _startCenter = const LatLng(
    AppGeneralValues.firstLatitude,
    AppGeneralValues.firstLongitude,
  ); // Coordenadas iniciais do mapa
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha a Localização'),
      ),
      body: Column(
        children: [
          // Primeira camada: Mensagem explicativa
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Arraste o mapa para escolher a região de seu interesse.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          // Segunda camada: Mapa com marcador central
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(initialCenter: _startCenter),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      tileProvider: CancellableNetworkTileProvider(),
                    )
                  ],
                ),
                const Center(
                  child: Icon(Icons.location_pin),
                )
              ],
            ),
          ),
          // Terceira camada: Botão de confirmação
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                final centerLatLng = _mapController.camera.center;
                final message =
                    'Latitude: ${centerLatLng.latitude}, Longitude: ${centerLatLng.longitude}';
                print(message);
                SnackbarHelper.showSnackBar(message);
              },
              child: const Text('Confirmar'),
            ),
          ),
        ],
      ),
    );
  }
}
