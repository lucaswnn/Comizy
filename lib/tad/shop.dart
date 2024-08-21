import 'package:comizy/tad/basic_market_item.dart';
import 'package:comizy/tad/selling.dart';

import 'package:latlong2/latlong.dart';

// classe de loja
class Shop extends BasicMarketItem {
  final String address;
  final LatLng location;
  Map<int, Selling> associatedProducts = {};

  Shop(
      {required int id,
      required String name,
      required this.address,
      required this.location,
      required String type})
      : super(name: name, type: type, id: id);
}
