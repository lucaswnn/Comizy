import 'dart:math';

import 'package:comizy/tads/help_request.dart';
import 'package:comizy/tads/neighborhood.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/price.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/product_type.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/tads/app_user.dart';
import 'package:comizy/tads/wallet.dart';
import 'package:latlong2/latlong.dart';

final mockNumberOfProductCategories = 3;
final mockProductCategories = List<ProductCategory>.generate(
    mockNumberOfProductCategories,
    (i) => ProductCategory('Cat$i', 'CatAsset$i'));

final mockNumberOfProductSubcategories = 5;
final mockProductSubcategories = List<ProductSubcategory>.generate(
    mockNumberOfProductSubcategories, (i) => ProductSubcategory('SubCat$i'));
final mockProductTypes = <ProductType>[
  for (final cat in mockProductCategories)
    for (final subcat in mockProductSubcategories)
      ProductType(mainCategory: cat, subcategory: subcat)
];

final mockNumberOfProducts = 20;

final mockProducts = List<Product>.generate(
  mockNumberOfProducts,
  (i) {
    final random = Random();
    return Product(
        id: i,
        name: 'Produto $i',
        description: 'Descrição do produto $i',
        productType: mockProductTypes[random.nextInt(mockProductTypes.length)],
        asset: '');
  },
);

final mockNumberOfShops = 4;

final mockNeighborhoods = const <Neighborhood>[
  Neighborhood(
    id: 1,
    city: 'Belo Horizonte',
    name: 'Castelo',
    latLng: LatLng(-19.88168932124855, -43.99881989962394),
  ),
  Neighborhood(
    id: 2,
    city: 'Belo Horizonte',
    name: 'Jaraguá',
    latLng: LatLng(-19.856591376019885, -43.95007233376536),
  ),
  Neighborhood(
    id: 3,
    city: 'São João del Rei',
    name: 'Colônia do Marçal',
    latLng: LatLng(-21.10444220262934, -44.22836114524594),
  ),
];

final mockShops = List<Shop>.generate(mockNumberOfShops, (i) {
  final actualLocation = const LatLng(-21.112631949836327, -44.23889486864758);
  return Shop(
    id: i,
    name: 'Loja $i',
    location: LatLng(
      actualLocation.latitude + (Random().nextDouble() - 0.5) * 0.05,
      actualLocation.longitude + (Random().nextDouble() - 0.5) * 0.05,
    ),
    neighborhood: mockNeighborhoods[Random().nextInt(mockNeighborhoods.length)],
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
    price: Price(
      value: (Random().nextDouble() * 100).roundToDouble(),
      unit: 'un.',
    ),
  );
  return market;
});

final mockNumberOfUsers = 50;
final mockMaxPoints = 1000;

final mockUsers = List.generate(
  mockNumberOfUsers,
  (i) => AppOtherUser(
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
    neighborhood: mockNeighborhoods[random.nextInt(mockNeighborhoods.length)],
    numberOfOrderers: random.nextInt(mockNumberOfHelpRequests - 1) + 1,
  );
}).toSet();

final mockMinimumShowcaseProducts = 5;
final mockMaxShowcaseItems = Random().nextInt(5) + mockMinimumShowcaseProducts;

final mockShowcaseProducts = List<ShowcaseItem>.generate(
  mockMaxShowcaseItems,
  (i) => ShowcaseItem(
    product: mockProducts[Random().nextInt(mockProducts.length)],
    neighborhood: mockNeighborhoods[Random().nextInt(mockNeighborhoods.length)],
  ),
).toSet();

final mockMaxShowcaseDays = 15;

final mockShowcaseProductPeriod = 7;

final mockShowcaseNewSpaceCost = 50;

final mockWalletCash = 125;

final mockMainUser = AppMainUser(
  name: 'Fulano',
  points: 100,
  number: 'number',
  wallet: Wallet(mockWalletCash),
);
