import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/command/async_command.dart';
import 'package:comizy/tads/help_submission.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';

enum SubmitPriceResult {
  success,
  notValidated,
  failure,
}

class SubmitPriceCommand implements AsyncCommand<SubmitPriceResult> {
  final HelpRequestNotifier helpRequestNotifier;
  final MarketNotifier marketNotifier;
  final bool Function() validator;
  final double Function() priceProvider;
  final Product product;
  final Shop shop;

  const SubmitPriceCommand({
    required this.helpRequestNotifier,
    required this.marketNotifier,
    required this.validator,
    required this.priceProvider,
    required this.product,
    required this.shop,
  });

  @override
  Future<SubmitPriceResult> execute() async {
    final isValidated = validator();
    if (!isValidated) {
      return SubmitPriceResult.notValidated;
    }

    final price = priceProvider();

    final wasSubmitted = await helpRequestNotifier.submitPriceToServer(
      HelpSubmissionData(
        product: product,
        shop: shop,
        value: price,
      ),
    );

    if (wasSubmitted) {
      marketNotifier.setOfferUpdated(
        Offer(
          product: product,
          shop: shop,
        ),
      );

      final needingUpdateOffers =
          marketNotifier.market.needingUpdateOffersFromProduct(product);
      if (needingUpdateOffers.isEmpty) {
        helpRequestNotifier.removeRequestByProduct(product);
      }
      return SubmitPriceResult.success;
    }

    return SubmitPriceResult.failure;
  }
}
