import 'package:comizy/tads/price.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';

class Offer implements Comparable<Offer> {
  final Product product;
  final Shop shop;
  final Price price;

  const Offer({
    required this.product,
    required this.shop,
    required this.price,
  });

  @override
  String toString() =>
      '${product.name} - ${shop.name} - $price';
      
        @override
        int compareTo(Offer other) {
          final productComparison = product.name.compareTo(other.product.name);
          if (productComparison != 0) return productComparison;
          final shopComparison = shop.name.compareTo(other.shop.name);
          if (shopComparison != 0) return shopComparison;
          return price.value.compareTo(other.price.value);
        }
}