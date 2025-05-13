import 'package:comizy/tads/product_type.dart';

class Product {
  final String name;
  final String description;
  final ProductType productType;
  final String asset;

  const Product({
    required this.name,
    required this.description,
    required this.productType,
    required this.asset,
  });

  @override
  String toString() => name;
}
