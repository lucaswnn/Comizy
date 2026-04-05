import 'dart:math';

import 'package:latlong2/latlong.dart';

double geoDistance(LatLng p1, LatLng p2) {
  double lat1 = p1.latitude;
  double lng1 = p1.longitude;
  double lat2 = p2.latitude;
  double lng2 = p2.longitude;
  const p = pi / 180;
  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lng2 - lng1) * p)) / 2;
  const radiusOfEarth = 6371;
  return radiusOfEarth * 2 * asin(sqrt(a));
}
