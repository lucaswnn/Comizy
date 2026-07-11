import 'package:comizy/tads/neighborhood.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';

class HelpRequest {
  final Product product;
  final Neighborhood neighborhood;
  final int numberOfOrderers;

  const HelpRequest({
    required this.product,
    required this.neighborhood,
    required this.numberOfOrderers,
  });

  @override
  String toString() => '$product - $neighborhood ($numberOfOrderers)';
}

class HelpedRequest {
  final Product product;
  final Shop shop;

  const HelpedRequest({
    required this.product,
    required this.shop,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HelpedRequest &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          shop == other.shop);

  @override
  int get hashCode => Object.hash(product, shop);

}