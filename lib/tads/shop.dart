import 'package:comizy/tads/neighborhood.dart';
import 'package:latlong2/latlong.dart';

class Shop implements Comparable<Shop> {
  final int id;
  final String name;
  final LatLng location;
  final Neighborhood neighborhood;

  const Shop({
    required this.id,
    required this.name,
    required this.location,
    required this.neighborhood,
  });

  factory Shop.fromJSON(Map<String, dynamic> shopData) {
    final int shopId = shopData['shop_id'];
    final String shopName = shopData['shop_name'];
    final double shopLat = shopData['shop_lat'];
    final double shopLng = shopData['shop_lng'];
    final shopLocation = LatLng(shopLat, shopLng);
    final Map<String, dynamic> neighborhoodData = shopData['neighborhoods'];
    final neighborhood = Neighborhood.fromJSON(neighborhoodData);

    return Shop(
      id: shopId,
      name: shopName,
      location: shopLocation,
      neighborhood: neighborhood,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shop &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => Object.hash(id, name);

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
