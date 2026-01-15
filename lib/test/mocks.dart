import 'dart:math';

import 'package:comizy/tads/help_request.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/price.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/product_type.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/tads/user.dart';

final mockProductTypes = ProductType.mainTypeMap.entries
    .expand(
      (entry) => entry.value.map(
        (subcat) => ProductType(
          mainCategory: entry.key,
          subcategory: subcat,
        ),
      ),
    )
    .toList();

final mockNumberOfProducts = 20;

final mockProducts = List<Product>.generate(mockNumberOfProducts, (i) {
  final random = Random();
  return Product(
      name: 'Produto $i',
      description: 'Descrição do produto $i',
      productType: mockProductTypes[random.nextInt(mockProductTypes.length)],
      asset: '');
});

final mockNumberOfShops = 4;

final mockShops = List<Shop>.generate(mockNumberOfShops, (i) {
  return Shop(name: 'Loja $i');
});

final mockOffers = mockShops.expand((shop) {
  final random = Random();
  final shuffled = List<Product>.from(mockProducts)..shuffle();
  final sample = shuffled.sublist(0, random.nextInt(mockProducts.length));
  return sample.map((product) {
    return Offer(
      product: product,
      shop: shop,
      price: Price((random.nextDouble() * 100).roundToDouble()),
    );
  });
}).toList();

final mockMarketOffers = mockOffers.fold<Set<Offer>>({}, (market, offer) {
  market.add(offer);
  return market;
});

final mockNumberOfUsers = 50;
final mockMaxPoints = 1000;

final mockUsers = List.generate(
  mockNumberOfUsers,
  (i) => OtherUser(
    name: 'Usuário $i',
    points: Random().nextInt(mockMaxPoints),
  ),
);

final mockNumberOfHelpRequests = 10;

final mockHelpRequests = List.generate(mockNumberOfHelpRequests, (i) {
  final random = Random();
  return HelpRequest(
    product: mockProducts[random.nextInt(mockProducts.length)],
    mainOrderer: mockUsers[random.nextInt(mockUsers.length)],
    numberOfOrderes: random.nextInt(mockNumberOfHelpRequests - 1) + 1,
  );
}).toSet();

final mockMinimumShowcaseProducts = 5;
final mockMaxShowcaseProducts =
    Random().nextInt(5) + mockMinimumShowcaseProducts;

final mockShowcaseProducts = List<Product>.generate(
  mockMaxShowcaseProducts,
  (i) => mockProducts[Random().nextInt(mockProducts.length)],
).toSet();

final mockMaxShowcaseDays = 15;

final mockShowcaseProductPeriod = 7;

final mockShowcaseProductsInfo =
    mockShowcaseProducts.fold<Map<Product, ShowcaseProductInfo>>(
  {},
  (map, product) {
    map[product] = ShowcaseProductInfo(
      addedAt: DateTime.now().subtract(
        Duration(
          days: Random().nextInt(mockMaxShowcaseDays),
        ),
      ),
    );
    return map;
  },
);
