import 'dart:math';

import 'package:comizy/tads/help_request.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/price.dart';
import 'package:comizy/test/mocks.dart';
import 'package:flutter/material.dart';

class HelpRequestNotifier with ChangeNotifier {
  final Set<HelpRequest> _helpRequests;

  HelpRequestNotifier() : _helpRequests = mockHelpRequests;

  Set<HelpRequest> get helpRequests => _helpRequests;

  Future<bool> submitPriceToServer({
    required Offer offer,
    required Price price,
  }) async {
    await Future.delayed(const Duration(seconds: 1), () {});
    
    if (Random().nextDouble() < 0.95) {
      return true;
    }
    
    return false;
  }
}
