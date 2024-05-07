import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:comizy/src/tad/selling.dart';
import 'package:comizy/src/util/string_util.dart';

class Product extends BasicMarketItem {
  Map<int, Selling> associatedShops = {};

  Product({
    required int id,
    required String name,
    required String type,
  }) : super(id: id, name: name, type: type);

  double meanValue() {
    if (associatedShops.isEmpty) {
      throw 'associatedShops not loaded yet';
    }
    return associatedShops.values.map((e) => e.value).reduce((a, b) => a + b) /
        associatedShops.length;
  }

  String meanValueFormatted() => realFormattedValue(meanValue());
}
