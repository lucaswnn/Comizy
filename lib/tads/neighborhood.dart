import 'package:latlong2/latlong.dart';

class Neighborhood {
  final int id;
  final String city;
  final String name;
  final LatLng latLng;

  const Neighborhood({
    required this.id,
    required this.city,
    required this.name,
    required this.latLng,
  });

  factory Neighborhood.fromJSON(Map<String, dynamic> neighborhoodData) {
    final int neighborhoodId = neighborhoodData['neighborhood_id'];
    final String neighborhoodName = neighborhoodData['neighborhood_name'];
    final Map<String, dynamic> cityData = neighborhoodData['cities'];
    final String cityName = cityData['city_name'];
    final double neighborhoodLat = neighborhoodData['neighborhood_lat'];
    final double neighborhoodLng = neighborhoodData['neighborhood_lng'];

    return Neighborhood(
      id: neighborhoodId,
      city: cityName,
      name: neighborhoodName,
      latLng: LatLng(neighborhoodLat, neighborhoodLng),
    );
  }

  @override
  String toString() => '$name - $city';
}
