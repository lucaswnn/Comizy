import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/test/mocks.dart';

class Market {
  final Set<Offer> _offers;

  Market():_offers = mockMarketOffers;
  
  Set<Offer> get offers => _offers;

  void addOffer(Offer offer) {
    _offers.add(offer);
  }

  void removeOffer(Offer offer) {
    _offers.remove(offer);
  }

  List<Offer> offersByProduct(Product product) {
    return _offers.where((offer) => offer.product == product).toList();
  }

  List<Product> get products {
    final productSet = <Product>{};
    for (var offer in _offers) {
      productSet.add(offer.product);
    }
    return productSet.toList();
  }
}
