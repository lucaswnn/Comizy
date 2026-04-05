import 'package:comizy/services/database/database_parser.dart';
import 'package:comizy/tads/neighborhood.dart';
import 'package:comizy/utils/geodistance.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum GPSStatus {
  disabled,
  permissionDenied,
  permissionDeniedForever,
  enabled,
}

class LocationNotifier with ChangeNotifier {
  static const LatLng defaultLocation = LatLng(-15.7801, -47.9292); // Brasília

  int? _maxRadiusDistanceinKm;
  set maxRadiusDistanceInKm(int distance) =>
      _maxRadiusDistanceinKm ??= distance;

  LatLng? _settedLocation;
  LatLng? get settedLocation => _settedLocation;

  LatLng? _currentLocation;
  LatLng? get currentLocation => _currentLocation;

  bool _isCurrentLocation = false;
  bool get isCurrentLocation => _isCurrentLocation;

  bool _isSettingLocation = false;
  bool get isSettingLocation => _isSettingLocation;

  Set<Neighborhood>? _neighborhoods;
  Set<Neighborhood>? get neighborhoods => _neighborhoods;

  Future<void> setNearestNeighborhoods()async{
    _neighborhoods = await DatabaseParser.getNeighborhoods();
  }

  Set<Neighborhood> getNearestNeighborhoods() {
    if (_settedLocation == null) {
      return {};
    }
    if(_maxRadiusDistanceinKm == null){
      return {};
    }
    return _neighborhoods
            ?.where((n) =>
                geoDistance(_settedLocation!, n.latLng) <=
                _maxRadiusDistanceinKm!)
            .toSet() ??
        {};
  }

  void setCustomLocation(LatLng loc) {
    _settedLocation = loc;
    _isCurrentLocation = false;
    notifyListeners();
  }

  Future<GPSStatus> askForGPS() async {
    if (kIsWeb) {
      try {
        final position = await Geolocator.getCurrentPosition();
        _currentLocation = LatLng(position.latitude, position.longitude);
        return GPSStatus.enabled;
      } catch (e) {
        return GPSStatus.permissionDenied;
      }
    }
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return GPSStatus.disabled;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        return GPSStatus.permissionDenied;
      }

      if (permission == LocationPermission.deniedForever) {
        return GPSStatus.permissionDeniedForever;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.best),
      );

      _currentLocation = LatLng(position.latitude, position.longitude);

      return GPSStatus.enabled;
    } catch (e) {
      return GPSStatus.disabled;
    }
  }

  Future<GPSStatus> ensureGPS() async {
    final status = await askForGPS();

    if (status == GPSStatus.disabled) {
      await Geolocator.openLocationSettings();
    }
    return status;
  }

  Future<GPSStatus> setCurrentLocation() async {
    _isSettingLocation = true;
    notifyListeners();

    final hasGPS = await ensureGPS();
    if (hasGPS != GPSStatus.enabled) {
      return hasGPS;
    }

    _settedLocation = _currentLocation;
    _isCurrentLocation = true;
    notifyListeners();
    return hasGPS;
  }
}
