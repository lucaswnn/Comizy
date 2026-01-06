import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:flutter/material.dart';
import 'package:comizy/utils/test_database.dart';

class ShowcaseChangeNotifier extends ChangeNotifier {
  Showcase _showcase = testShowcase;
  Showcase get showcase => _showcase;

  Future<void> initializeShowcase({
    required List<Product> fixedProducts,
    required Map<Product, DateTime> tempProducts,
    required Map<Offer, DateTime> tempOffers,
  }) async {
    _showcase = Showcase.withProductsAndOffers(
      fixedProducts: fixedProducts,
      tempProducts: tempProducts,
      tempOffers: tempOffers,
    );
    notifyListeners();
  }

  void addProduct(Product product) {
    _showcase.addFixedProduct(product);
    notifyListeners();
  }

  void clearShowcase() {
    _showcase.clearFixedProducts();
    notifyListeners();
  }
}
