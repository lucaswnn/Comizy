import 'package:comizy/tads/help_request.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';

class HelpRequests {
  final Set<HelpRequest> _helpRequestItems;
  final Set<HelpedRequest> _helpedRequestItems;

  Set<HelpRequest> get helpRequestItems => _helpRequestItems;
  Set<HelpedRequest> get helpedRequestItems => _helpedRequestItems;

  HelpRequests({
    required Set<HelpRequest> helpRequests,
    Set<HelpedRequest>? helpedRequests,
  })  : _helpRequestItems = helpRequests,
        _helpedRequestItems = helpedRequests ?? {};

  void removeRequest({
    required Product product,
    required Shop shop,
  }) {
    _helpedRequestItems.add(
      HelpedRequest(
        product: product,
        shop: shop,
      ),
    );
  }
}
