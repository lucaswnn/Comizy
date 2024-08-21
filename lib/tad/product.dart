import 'package:comizy/tad/basic_market_item.dart';
import 'package:comizy/tad/selling.dart';

// classe de produto
class Product extends BasicMarketItem {
  Map<int, Selling> associatedShops = {};

  Product({
    required int id,
    required String name,
    required String type,
    required String subtype,
  }) : super(id: id, name: name, type: type, subtype: subtype);
}
