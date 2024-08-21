import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'dart:developer' as developer;

// calcula distância por meio de duas coordenadas
double calculateDistance(LatLng latLng1, LatLng latLng2) {
  double p = 0.017453292519943295;
  double lat1 = latLng1.latitude, lat2 = latLng2.latitude;
  double lon1 = latLng1.longitude, lon2 = latLng2.longitude;

  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

// checa permissões de localização do GPS
Future<bool> checkGPSPermission() async {
  final location = Location();
  PermissionStatus permissionGranted;
  permissionGranted = await location.hasPermission();

  if (permissionGranted == PermissionStatus.denied ||
      permissionGranted == PermissionStatus.deniedForever) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return false;
    }
  }
  return true;
}

// checa se a localização está ativada
Future<bool> checkGPSEnabled() async {
  bool serviceEnabled;
  final location = Location();
  serviceEnabled = await location.serviceEnabled();

  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return false;
    }
  }
  return true;
}

// captura a localização atual
Future<LocationData?> getCurrentLocation() async {
  try {
    final isGPSEnabled = await checkGPSEnabled();
    final isGPSPermitted = await checkGPSPermission();
    if (isGPSPermitted && isGPSEnabled) {
      return await Location().getLocation();
    }
  } catch (error) {
    const debugOrigin = 'geo_util:getCurrentLocation';
    developer.log('comizy: exception on $debugOrigin: $error');
    throw 'Localização não adquirida';
  }
  return null;
}
