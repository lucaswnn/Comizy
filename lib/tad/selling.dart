import 'package:comizy/tad/product.dart';
import 'package:comizy/tad/shop.dart';
import 'package:comizy/util/string_util.dart' as string_util;

class Selling {
  final Shop shop;
  final Product product;
  final double value;

  const Selling({
    required this.shop,
    required this.product,
    required this.value,
  });

  String get realFormattedValue => string_util.realFormattedValue(value);
}
