import 'dart:collection';

import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';

class Showcase {
  final List<Product> _fixedProducts = [];
  final Map<Product, DateTime> _tempProducts = {};
  final Map<Offer, DateTime> _tempOffers = {};

  Showcase.withProductsAndOffers({
    required List<Product> fixedProducts,
    required Map<Product, DateTime> tempProducts,
    required Map<Offer, DateTime> tempOffers,
  }) {
    addFixedProducts(fixedProducts);
    addTempProducts(tempProducts);
    addTempOffers(tempOffers);
    _organizeShowcase();
  }

  void _organizeShowcase(){
    for(var fixedProduct in _fixedProducts){
      _tempProducts.removeWhere((p, _)=>p==fixedProduct);
    }
    for(var tempProduct in _tempProducts.keys){
      _tempOffers.removeWhere((o,_)=>o.product==tempProduct);
    }
  }

  void clearShowcase() {
    clearFixedProducts();
    clearTempProducts();
    clearTempOffers();
  }

  UnmodifiableListView<Product> get fixedProducts =>
      UnmodifiableListView(_fixedProducts);

  void addFixedProduct(Product product) => _fixedProducts.add(product);

  void addFixedProducts(List<Product> products) =>
      _fixedProducts.addAll(products);

  void removeFixedProduct(Product product) => _fixedProducts.remove(product);

  void clearFixedProducts() => _fixedProducts.clear();

  bool containsFixedProduct(Product product) {
    return _fixedProducts.contains(product);
  }

  UnmodifiableListView<Product> get tempProducts =>
      UnmodifiableListView(_tempProducts.keys);

  void addTempProduct(Product product, DateTime date) =>
      _tempProducts[product] = date;

  void addTempProducts(Map<Product, DateTime> products) =>
      _tempProducts.addAll(products);

  void removeTempProduct(Product product) => _tempProducts.remove(product);

  void clearTempProducts() => _tempProducts.clear();

  bool containsTempProduct(Product product) =>
      _tempProducts.containsKey(product);

  UnmodifiableListView<Offer> get tempOffers =>
      UnmodifiableListView(_tempOffers.keys);

  void addTempOffer(Offer offer, DateTime date) => _tempOffers[offer] = date;

  void addTempOffers(Map<Offer, DateTime> offers) => _tempOffers.addAll(offers);

  void removeTempOffer(Offer offer) => _tempOffers.remove(offer);

  void clearTempOffers() => _tempOffers.clear();

  bool containsTempOffer(Offer offer) => _tempOffers.containsKey(offer);
}
