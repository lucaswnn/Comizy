import 'package:comizy/services/change_notifiers/database_loadable.dart';
import 'package:comizy/services/database/database_parser.dart';
import 'package:comizy/tads/help_requests.dart';
import 'package:comizy/tads/help_submission.dart';
import 'package:comizy/tads/neighborhood.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';
import 'package:flutter/material.dart';

class NullNeighborhoodException implements Exception {
  final String message;
  NullNeighborhoodException(this.message);

  @override
  String toString() => 'NullNeighborhoodException: $message';
}

class NullHelpRequestsException implements Exception {
  final String message;
  NullHelpRequestsException(this.message);

  @override
  String toString() => 'NullNeighborhoodException: $message';
}

class HelpRequestNotifier extends DatabaseLoadable with ChangeNotifier {
  HelpRequests? _helpRequests;

  HelpRequests get helpRequests {
    if (_helpRequests == null) {
      throw NullHelpRequestsException('helpRequests não foi inicializado');
    }
    return _helpRequests!;
  }

  set helpRequests(HelpRequests? helpRequests) {
    _helpRequests = helpRequests;
    notifyListeners();
  }

  Product? _currentProductRequest;
  Product? get currentProductRequest => _currentProductRequest;

  set currentProductRequest(Product? product) {
    _currentProductRequest = product;
    notifyListeners();
  }

  void removeRequest({required Product product,
  required Shop shop,}) {
    _helpRequests?.removeRequest(product: product, shop: shop);
    notifyListeners();
  }

  Set<Neighborhood>? neighborhoods;

  Future<SubmitPriceStatus> submitPriceToServer(
    HelpSubmissionData helpData,
  ) async {
    try {
      return await DatabaseParser.submitPriceOffer(helpData);
    } catch (e) {
      return SubmitPriceStatus.error;
    }
  }

  @override
  Future<void> handleLoadData() async {
    if (neighborhoods == null) {
      throw NullNeighborhoodException(
          'sem vizinhança carregada para definir helpRequests');
    }

    final requestsFuture = DatabaseParser.getHelpRequests(neighborhoods!);
    final helpedFuture = DatabaseParser.getLastHelpedSubmissions();
    final requests = await requestsFuture;
    final helpedRequests = await helpedFuture;

    _helpRequests = HelpRequests(
      helpRequests: requests.helpRequestItems,
      helpedRequests: helpedRequests,
    );
  }
}
