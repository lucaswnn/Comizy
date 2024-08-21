import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';

import 'package:comizy/util/geo_util.dart';

class GeoState extends ChangeNotifier {
  // localização atual GPS
  LocationData? currentLocation;

  // controle do mapa
  final mapController = MapController();

  // localização carregada ou não
  bool? isLocationLoaded;

  // método para carregar localização atual
  Future<void> loadLocation() async {
    if (isLocationLoaded == null) {
      currentLocation = await getCurrentLocation();
      currentLocation != null
          ? isLocationLoaded = true
          : isLocationLoaded = false;
      notifyListeners();
    }
  }

  // método para recarregar localização atual
  Future<void> reloadLocation() async {
    isLocationLoaded = false;
    currentLocation = await getCurrentLocation();
    if (currentLocation != null) {
      isLocationLoaded = true;
      notifyListeners();
    }
  }
}
