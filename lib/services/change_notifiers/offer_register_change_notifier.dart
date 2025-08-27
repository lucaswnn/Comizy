import 'package:comizy/tads/offer.dart';
import 'package:comizy/utils/test_database.dart';
import 'package:flutter/material.dart';

class OfferRegisterChangeNotifier extends ChangeNotifier {
  final Set<Offer> _offerRegisters = testOfferRegisters.toSet();
  Offer? _currentOffer;

  Offer? get currentOffer => _currentOffer ?? _offerRegisters.first;

  Offer? _getOriginalOffer(Offer offer) {
    try {
      return _offerRegisters.firstWhere((other) =>
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

  List<Offer> get offerRegisters => _offerRegisters.toList();

  void registerCurrentOffer() {
    if (_currentOffer != null) {
      final originalOffer = _getOriginalOffer(_currentOffer!);
      if (originalOffer != null) {
        _offerRegisters.remove(originalOffer);
        notifyListeners();
      }
    }
  }
}
