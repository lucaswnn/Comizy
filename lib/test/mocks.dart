import 'dart:math';

import 'package:comizy/tads/help_request.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/price.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/product_type.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/tads/user.dart';
import 'package:latlong2/latlong.dart';

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
  final actualLocation = const LatLng(-21.112631949836327, -44.23889486864758);
  return Shop(
    name: 'Loja $i',
    location: LatLng(
      actualLocation.latitude + (Random().nextDouble() - 0.5) * 0.05,
      actualLocation.longitude + (Random().nextDouble() - 0.5) * 0.05,
    ),
  );
});

final mockOffers = mockShops.expand((shop) {
  final random = Random();
  final shuffled = List<Product>.from(mockProducts)..shuffle();
  final sample = shuffled.sublist(0, random.nextInt(mockProducts.length));
  return sample.map((product) {
    return Offer(
      product: product,
      shop: shop,
    );
  });
}).toList();

final mockMarketOffers =
    mockOffers.fold<Map<Offer, OfferInfo>>({}, (market, offer) {
  market[offer] = OfferInfo(
    lastUpdated: DateTime.now().subtract(
      Duration(
        days: Random().nextInt(15),
      ),
    ),
    needsUpdate: Random().nextBool(),
    price: Price((Random().nextDouble() * 100).roundToDouble()),
  );
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
  final offers = mockMarketOffers.entries
      .where((e) => e.value.needsUpdate)
      .map((e) => e.key)
      .toList();
  final products = offers.fold<Set<Product>>({}, (set, offer) {
    set.add(offer.product);
    return set;
  }).toList();
  return HelpRequest(
    product: products[random.nextInt(products.length)],
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
