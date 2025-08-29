import 'dart:math';

import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/product_type.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/values/app_assets.dart';

final testProducts = List<Product>.generate(
  50,
  (index) {
    final random = Random();
    final typeValues = ProductCategory.values;
    final type = typeValues[random.nextInt(typeValues.length)];
    final subtypeValues = ProductSubcategory.values;
    final subtype = subtypeValues[random.nextInt(subtypeValues.length)];
    final productType = ProductType(
      mainCategory: type,
      subcategory: subtype,
    );
    return Product(
        name: 'Produto $index',
        description: 'Possui o tipo $type e subtipo $subtype',
        productType: productType,
        asset: AppAssets.simpleLogoSmall);
  },
);

final testOffers = List<Offer>.generate(
  50,
  (index) {
    final r = Random();
    return Offer(
      product: testProducts[r.nextInt(testProducts.length)],
      shop: testShops[r.nextInt(testShops.length)],
      price: r.nextDouble() * 100,
    );
  },
);

final testShops = List<Shop>.generate(
  50,
  (index) => Shop(name: 'Loja $index'),
);

final testShowcase = Showcase.withProducts(
  products: List.generate(
    2,
    (int index) {
      final r = Random();
      return testProducts[r.nextInt(testProducts.length)];
    },
  ),
  showcaseLimit: 2,
);

final testOfferRegisters = List<Offer>.generate(
  10,
  (index) {
    final r = Random();
    return Offer(
      product: testProducts[r.nextInt(testProducts.length)],
      shop: testShops[r.nextInt(testShops.length)],
      price: 0,
    );
  },
);
