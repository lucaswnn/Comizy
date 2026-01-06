import 'package:comizy/tads/offer.dart';
import 'package:comizy/utils/test_database.dart';
import 'package:flutter/material.dart';

class OfferRegisterChangeNotifier extends ChangeNotifier {
  final Map<Offer, OfferRegisterInfo> _offerRegisters = {
    for (var x in testOfferRegisters.toSet()) x: OfferRegisterInfo.avaible
  };
  Offer? _currentOffer;

  Offer? get currentOffer => _currentOffer;

  Offer? _getOriginalOffer(Offer offer) {
    try {
      return _offerRegisters.keys.firstWhere((other) =>
          other.product == offer.product && other.shop == offer.shop);
    } on StateError catch (_) {
      return null;
    }
  }

  set currentOffer(Offer? offer) {
    if (offer != null && _getOriginalOffer(offer) != null) {
      _currentOffer = offer;
      notifyListeners();
    }
  }

  List<Offer> get avaibleOfferRegisters => _offerRegisters.keys
      .where((offer) => _offerRegisters[offer] == OfferRegisterInfo.avaible)
      .toList();

  List<Offer> get pendingOfferRegisters => _offerRegisters.keys
      .where((offer) => _offerRegisters[offer] == OfferRegisterInfo.pending)
      .toList();

  List<Offer> get refusedOfferRegisters => _offerRegisters.keys
      .where((offer) => _offerRegisters[offer] == OfferRegisterInfo.refused)
      .toList();

  void registerCurrentOffer() {
    if (_currentOffer != null) {
      final originalOffer = _getOriginalOffer(_currentOffer!);
      if (originalOffer != null) {
        _offerRegisters.remove(originalOffer);
        _offerRegisters[_currentOffer!] = OfferRegisterInfo.pending;
        notifyListeners();
      }
    }
  }
}

enum OfferRegisterInfo {
  avaible,
  pending,
  refused,
}
