import 'package:comizy/src/tad/product.dart';

import 'package:latlong2/latlong.dart';

class Shop {
  final int id;
  final String name;
  final String address;
  final LatLng location;
  List<Product>? products;

  Shop(this.id, this.name, this.address, this.location) {
    products = [];
  }

  Shop.withProducts(
      this.id, this.name, this.address, this.location, this.products);
}
