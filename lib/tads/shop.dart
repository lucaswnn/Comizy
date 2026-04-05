import 'package:comizy/tads/neighborhood.dart';
import 'package:latlong2/latlong.dart';

class Shop implements Comparable<Shop> {
  final String name;
  final LatLng location;
  final Neighborhood neighborhood;

  const Shop({
    required this.name,
    required this.location,
    required this.neighborhood,
  });

  @override
  String toString() => name;

  @override
  int compareTo(Shop other) => name.compareTo(other.name);

  static int Function(Shop, Shop) compareWithDistance(LatLng loc) {
    final distance = const Distance();
    return (Shop a, Shop b) {
      final distA = distance(loc, a.location);
      final distB = distance(loc, b.location);
      return distA.compareTo(distB);
    };
  }
}
