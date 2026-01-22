import 'package:comizy/tads/product.dart';
import 'package:comizy/test/mocks.dart';

enum ShowcaseAddStatus {
  success,
  alreadyExists,
  limitReached,
}

enum ShowcaseRemoveStatus {
  success,
  productNotFound,
  notEnoughTime,
}

class Showcase {
  final Map<Product, ShowcaseProductInfo> showcaseProducts;
  final int maxShowcaseProducts;
  final int maxShowcaseDays;

  Showcase()
      : showcaseProducts = mockShowcaseProductsInfo,
        maxShowcaseProducts = mockMaxShowcaseProducts,
        maxShowcaseDays = mockShowcaseProductPeriod;

  bool get isShowcaseFull => showcaseProducts.length >= maxShowcaseProducts;

  ShowcaseAddStatus addShowcaseProduct(Product product) {
    if (showcaseProducts.length >= maxShowcaseProducts) {
      return ShowcaseAddStatus.limitReached;
    }
    if (showcaseProducts.containsKey(product)) {
      return ShowcaseAddStatus.alreadyExists;
    }
    showcaseProducts[product] = ShowcaseProductInfo(addedAt: DateTime.now());
    return ShowcaseAddStatus.success;
  }

  ShowcaseRemoveStatus removeShowcaseProduct(Product product) {
    if (!showcaseProducts.containsKey(product)) {
      return ShowcaseRemoveStatus.productNotFound;
    }
    final addedAt = showcaseProducts[product]!.addedAt;
    if (DateTime.now().difference(addedAt).inDays < maxShowcaseDays) {
      return ShowcaseRemoveStatus.notEnoughTime;
    }
    showcaseProducts.remove(product);
    return ShowcaseRemoveStatus.success;
  }
}

class ShowcaseProductInfo {
  final DateTime addedAt;

  ShowcaseProductInfo({
    required this.addedAt,
  });
}
