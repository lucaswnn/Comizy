import 'package:comizy/tads/market.dart';
import 'package:comizy/tads/offer.dart';
import 'package:flutter/material.dart';

class MarketNotifier with ChangeNotifier {
  final Market _market = Market();

  Market get market => _market;

  void setOfferUpdated(Offer offer) {
    _market.setOfferUpdated(offer);
    notifyListeners();
  }
}
