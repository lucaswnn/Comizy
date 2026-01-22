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

  LatLng? _settedLocation;
  LatLng? get settedLocation => _settedLocation;

  LatLng? _currentLocation;
  LatLng? get currentLocation => _currentLocation;

  bool _isCurrentLocation = false;
  bool get isCurrentLocation => _isCurrentLocation;

  bool _isSettingLocation = false;
  bool get isSettingLocation => _isSettingLocation;

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
        desiredAccuracy: LocationAccuracy.best,
      );

      _currentLocation = LatLng(position.latitude, position.longitude);

      return GPSStatus.enabled;
    } catch (e) {
      return GPSStatus.disabled;
    }
  }

  Future<bool> ensureGPS() async {
    final status = await askForGPS();
    switch (status) {
      case GPSStatus.disabled:
        {
          await Geolocator.openLocationSettings();
          return false;
        }
      case GPSStatus.permissionDenied:
      case GPSStatus.permissionDeniedForever:
        return false;
      case GPSStatus.enabled:
        return true;
    }
  }

  Future<void> setCurrentLocation({
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    _isSettingLocation = true;
    notifyListeners();

    final hasGPS = await ensureGPS();
    if (!hasGPS) {
      _isSettingLocation = false;
      onFailure.call();
      notifyListeners();
      return;
    }

    _settedLocation = _currentLocation;
    _isCurrentLocation = true;

    _isSettingLocation = false;
    onSuccess.call();
    notifyListeners();
  }
}

class NoGPSException implements Exception {
  final String message;
  NoGPSException([this.message = 'GPS is not enabled or permission denied.']);

  @override
  String toString() => 'NoGPSException: $message';
}
