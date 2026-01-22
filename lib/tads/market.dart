import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/test/mocks.dart';

class Market {
  final Map<Offer, OfferInfo> _offers;

  Market() : _offers = mockMarketOffers;

  Map<Offer, OfferInfo> get offers => _offers;

  void addOffer(Offer offer, OfferInfo info) {
    _offers.putIfAbsent(offer, () => info);
  }

  void removeOffer(Offer offer) {
    _offers.remove(offer);
  }

  Map<Offer, OfferInfo> offersByProduct(Product product) {
    return Map.fromEntries(
        _offers.entries.where((offer) => offer.key.product == product));
  }

  List<Product> get products {
    final productSet = <Product>{};
    for (final offer in _offers.entries) {
      productSet.add(offer.key.product);
    }
    return productSet.toList();
  }

  List<Shop> get shops {
    final shopSet = <Shop>{};
    for (var offer in _offers.entries) {
      shopSet.add(offer.key.shop);
    }
    return shopSet.toList();
  }

  Map<Offer, OfferInfo> needingUpdateOffers(Shop shop) {
    return Map<Offer, OfferInfo>.fromEntries(_offers.entries
        .where((entry) => entry.key.shop == shop && entry.value.needsUpdate));
  }

  void setOfferUpdated(Offer offer) {
    final info = _offers[offer];
    if (info == null) return;
    _offers[offer] = OfferInfo(
      lastUpdated: info.lastUpdated,
      needsUpdate: false,
      price: info.price,
    );
  }
}
