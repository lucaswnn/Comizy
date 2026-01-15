import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:flutter/material.dart';

class ShowcaseNotifier with ChangeNotifier {
  final Showcase _showcase = Showcase();

  Showcase get showcase => _showcase;

  ShowcaseAddStatus addShowcaseProduct(Product product) {
    final status = _showcase.addShowcaseProduct(product);
    if (status != ShowcaseAddStatus.success) {
      return status;
    }
    notifyListeners();
    return status;
  }

  ShowcaseRemoveStatus removeShowcaseProduct(Product product) {
    final status = _showcase.removeShowcaseProduct(product);
    if (status != ShowcaseRemoveStatus.success) {
      return status;
    }
    notifyListeners();
    return status;
  }
}
