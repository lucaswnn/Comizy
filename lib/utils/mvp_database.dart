import 'dart:math';

import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/product_type.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/values/app_assets.dart';

final mvpProducts = List<Product>.generate(
  50,
  (index) {
    final random = Random();
    final typeValues = ProductMainType.values;
    final type = typeValues[random.nextInt(typeValues.length)];
    final subtypeValues = ProductSecondaryType.values;
    final subtype = subtypeValues[random.nextInt(subtypeValues.length)];
    final productType = ProductType(
      mainType: type,
      secondaryType: subtype,
    );
    return Product(
        name: 'Produto $index',
        description: 'Possui o tipo $type e subtipo $subtype',
        productType: productType,
        asset: AppAssets.simpleLogoSmall);
  },
);

final sampleShowcase = Showcase.withProducts(
  products: List.generate(
    2,
    (int index) {
      final r = Random();
      return mvpProducts[r.nextInt(mvpProducts.length)];
    },
  ),
  showcaseLimit: 2,
);
