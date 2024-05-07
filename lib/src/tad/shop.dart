import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:comizy/src/tad/selling.dart';

import 'package:latlong2/latlong.dart';

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

  Shop.empty()
      : address = '',
        location = const LatLng(0, 0),
        super(name: '', type: '', id: -1);

  bool get isEmpty => id == -1 ? true : false;
}
