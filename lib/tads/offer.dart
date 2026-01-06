import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';

class Offer {
  final Product product;
  final Shop shop;
  final double price;
  final DateTime date;

  const Offer({
    required this.product,
    required this.shop,
    required this.price,
    required this.date,
  });

  @override
  String toString() =>
      '${product.name} - ${shop.name} - \$${price.toStringAsFixed(2)}';
}
