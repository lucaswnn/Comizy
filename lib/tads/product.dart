import 'package:comizy/tads/product_type.dart';

class Product implements Comparable<Product> {
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

  @override
  int compareTo(Product other) {
    return name.compareTo(other.name);
  }

  static int compareByType(Product a, Product b) {
    final typeComparison = a.productType.compareTo(b.productType);
    if (typeComparison != 0) {
      return typeComparison;
    }
    return a.name.compareTo(b.name);
  }
}
