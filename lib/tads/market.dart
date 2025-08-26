import 'dart:collection';
import 'package:comizy/tads/offer.dart';

class Market {
  final List<Offer> _offers = [];

  Market.withOffers({required List<Offer> offers}) {
    addOffers(offers);
  }

  void addOffer(Offer offer) {
    _offers.add(offer);
  }

  void addOffers(List<Offer> offers) {
    _offers.addAll(offers);
  }

  operator[](int index) => _offers[index];

  UnmodifiableListView<Offer> get offers => UnmodifiableListView(_offers);
}
