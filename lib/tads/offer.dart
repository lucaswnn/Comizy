import 'package:comizy/tads/price.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';

class Offer implements Comparable<Offer> {
  final Product product;
  final Shop shop;

  const Offer({
    required this.product,
    required this.shop,
  });

  @override
  String toString() => '${product.name} - ${shop.name}';

  @override
  int compareTo(Offer other) {
    final productComparison = product.name.compareTo(other.product.name);
    if (productComparison != 0) return productComparison;
    return shop.name.compareTo(other.shop.name);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Offer &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          shop == other.shop);

  @override
  int get hashCode => Object.hash(product, shop);
}

class OfferInfo {
  final DateTime lastUpdated;
  final bool needsUpdate;
  final Price price;

  const OfferInfo({
    required this.lastUpdated,
    required this.needsUpdate,
    required this.price,
  });

  @override
  String toString() =>
      '$price (última atualização: $lastUpdated - ${needsUpdate ? "" : "não "}precisa atualizar)';
}
