import 'package:comizy/src/product.dart';

import 'package:latlong2/latlong.dart';

class Shop {
  final int id;
  final String name;
  final LatLng location;
  List<Product>? products;

  Shop(this.id, this.name, this.location) {
    products = [];
  }

  Shop.withProducts(this.id, this.name, this.location, this.products);
}