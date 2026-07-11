import 'package:comizy/tads/help_requests.dart';
import 'package:comizy/tads/help_request.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';

class Market {
  final Map<Offer, OfferInfo> _offers = {};

  Map<Offer, OfferInfo> get offers => _offers;

  void addOffer(Offer offer, OfferInfo info) {
    _offers.putIfAbsent(offer, () => info);
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

  Map<Offer, OfferInfo> filterOffersByHelpRequests(HelpRequests helpRequests) {
    final requests = helpRequests.helpRequestItems;
    final helpedRequests = helpRequests.helpedRequestItems;

    final filteredOffersByNeedingUpdate = Map<Offer, OfferInfo>.fromEntries(
      _offers.entries.where(
        (entry) => entry.value.needsUpdate,
      ),
    );

    final filteredOffersByNeighborhood = Map<Offer, OfferInfo>.fromEntries(
      filteredOffersByNeedingUpdate.entries.where(
        (entry) => requests.any(
          (r) => r.neighborhood == entry.key.shop.neighborhood,
        ),
      ),
    );

    final filteredOffersThatContainsPruducts =
        Map<Offer, OfferInfo>.fromEntries(
      filteredOffersByNeighborhood.entries.where(
        (entry) => requests.any(
          (r) => r.product == entry.key.product,
        ),
      ),
    );

    return Map<Offer, OfferInfo>.fromEntries(
      filteredOffersThatContainsPruducts.entries.where(
        (entry) => !helpedRequests.contains(
          HelpedRequest(
            product: entry.key.product,
            shop: entry.key.shop,
          ),
        ),
      ),
    );
  }

  bool productNeedsUpdate(Product product) {
    return _offers.entries.any(
        (entry) => entry.key.product == product && entry.value.needsUpdate);
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
