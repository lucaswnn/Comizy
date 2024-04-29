import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';
import 'package:comizy/src/util/string_util.dart' as string_util;

class Selling {
  final Shop shop;
  final Product product;
  final double value;
  final String lastUpdate;

  const Selling({
    required this.shop,
    required this.product,
    required this.value,
    required this.lastUpdate,
  });

  String get realFormattedValue => string_util.realFormattedValue(value);

  String get lastUpdateFormatted =>
      string_util.mySqlDateConversion(lastUpdate.substring(0, 10));
}
