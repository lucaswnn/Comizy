import 'dart:collection';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/product_type.dart';
import 'package:comizy/tads/shop.dart';

class Market {
  final List<Offer> _offers = [];

  Market.withOffers({required List<Offer> offers}) {
    addOffers(offers);
  }

  void addOffer(Offer offer) {
    _offers.add(offer);
  }

  void addOffers(List<Offer> offers) {
    _offers.addAll(offers);
  }

  operator [](int index) => _offers[index];

  List<Offer> productOffers(Product product) =>
      _offers.where((offer) => offer.product == product).toList();

  List<Shop> productShops(Product product) => _offers
      .where((offer) => offer.product == product)
      .map((offer) => offer.shop)
      .toSet()
      .toList();

  List<Product> shopProducts(Shop shop) => _offers
      .where((offer) => offer.shop == shop)
      .map((offer) => offer.product)
      .toSet()
      .toList();

  List<Offer> shopOffers(Shop shop) =>
      _offers.where((offer) => offer.shop == shop).toList();

  List<Offer> shopOffersByCategory(
    Shop shop,
    ProductCategory category,
  ) =>
      _offers
          .where((offer) =>
              offer.shop == shop &&
              offer.product.productType.mainCategory == category)
          .toList();

  List<ProductType> shopProductTypes(Shop shop) =>
      shopProducts(shop).map((product) => product.productType).toSet().toList();

  List<Product> get products =>
      _offers.map((offer) => offer.product).toSet().toList();

  List<Shop> get shops => _offers.map((offer) => offer.shop).toSet().toList();

  UnmodifiableListView<Offer> get offers => UnmodifiableListView(_offers);
}
