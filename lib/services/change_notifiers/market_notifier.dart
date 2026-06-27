import 'package:comizy/services/change_notifiers/database_loadable.dart';
import 'package:comizy/services/database/database_parser.dart';
import 'package:comizy/tads/market.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/shop.dart';
import 'package:flutter/material.dart';

class NullMarketException implements Exception {
  final String message;
  NullMarketException(this.message);

  @override
  String toString() => 'NullMarketException: $message';
}

class MarketNotifier extends DatabaseLoadable with ChangeNotifier {
  Market? _market;

  Market get market {
    if (_market == null) {
      throw NullMarketException('Market não foi inicializado');
    }
    return _market!;
  }

  void setOfferUpdated(Offer offer) {
    if (_market == null) {
      throw NullMarketException('Market não foi inicializado');
    }
    _market!.setOfferUpdated(offer);
    notifyListeners();
  }

  Map<Offer, OfferInfo> needingUpdateOffersOnShop(Shop shop) {
    if (_market == null) {
      throw NullMarketException('Market não foi inicializado');
    }
    return _market!.needingUpdateOffersOnShop(shop);
  }

  @override
  Future<void> handleLoadData() async {
    _market = await DatabaseParser.getMarket();
  }
}
