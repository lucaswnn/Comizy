import 'package:latlong2/latlong.dart';

class Neighborhood {
  final String city;
  final String name;
  final LatLng latLng;

  const Neighborhood({
    required this.city,
    required this.name,
    required this.latLng,
  });

  @override
  String toString() => '$name - $city';
}
