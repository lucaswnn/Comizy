import 'package:comizy/tads/help_request.dart';
import 'package:comizy/tads/product.dart';

class HelpRequests {
  final Set<HelpRequest> _helpRequestItems;
  Set<HelpRequest> get helpRequestItems => _helpRequestItems;

  const HelpRequests({
    required Set<HelpRequest> helpRequests,
  }) : _helpRequestItems = helpRequests;

  void removeRequestByProduct(Product product) {
    _helpRequestItems.removeWhere((req) => req.product == product);
  }
}


