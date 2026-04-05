import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/test/mocks.dart';

class Market {
  final Set<Product> _products={};
  final Set<Shop> _shops={};
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

  Set<Product> get products => Market.productsFromOffers(_offers);

  Set<Shop> get shops => Market.shopsFromOffers(_offers);

  Map<Offer, OfferInfo> needingUpdateOffersOnShop(Shop shop) {
    return Map<Offer, OfferInfo>.fromEntries(
      _offers.entries
          .where((entry) => entry.key.shop == shop && entry.value.needsUpdate),
    );
  }

  Map<Offer, OfferInfo> needingUpdateOffersFromProduct(Product product) {
    return Map<Offer, OfferInfo>.fromEntries(
      _offers.entries.where(
          (entry) => entry.key.product == product && entry.value.needsUpdate),
    );
  }

  static Set<Shop> shopsFromOffers(Map<Offer, OfferInfo> map) {
    return map.entries.fold(
      {},
      (set, item) {
        set.add(item.key.shop);
        return set;
      },
    );
  }

  static Set<Product> productsFromOffers(Map<Offer, OfferInfo> map) {
    return map.entries.fold({}, (set, item) {
      set.add(item.key.product);
      return set;
    });
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
