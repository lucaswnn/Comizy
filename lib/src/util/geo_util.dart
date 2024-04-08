import 'dart:math';
import 'package:latlong2/latlong.dart';

double calculateDistance(LatLng latLng1, LatLng latLng2) {
    double p = 0.017453292519943295;
    double lat1 = latLng1.latitude, lat2 = latLng2.latitude;
    double lon1 = latLng1.longitude, lon2 = latLng2.longitude;

    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }