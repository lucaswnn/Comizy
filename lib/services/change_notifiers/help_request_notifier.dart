import 'dart:math';

import 'package:comizy/tads/help_request.dart';
import 'package:comizy/tads/help_submission.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/test/mocks.dart';
import 'package:flutter/material.dart';

class HelpRequestNotifier with ChangeNotifier {
  final Set<HelpRequest> _helpRequests;

  HelpRequestNotifier() : _helpRequests = mockHelpRequests;

  Set<HelpRequest> get helpRequests => _helpRequests;

  Product? _currentProductRequest;

  Product? get currentProductRequest => _currentProductRequest;

  set currentProductRequest(Product? product) {
    _currentProductRequest = product;
    notifyListeners();
  }

  void removeRequestByProduct(Product product) {
    _helpRequests.removeWhere((req) => req.product == product);
    notifyListeners();
  }

  Future<bool> submitPriceToServer(
    HelpSubmissionData helpData,
  ) async {
    await Future.delayed(const Duration(seconds: 1), () {});

    if (Random().nextDouble() < 0.95) {
      return true;
    }

    return false;
  }
}
