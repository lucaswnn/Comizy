import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/database/database_parser.dart';
import 'package:comizy/services/command/async_command.dart';
import 'package:comizy/tads/help_submission.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';

enum SubmitPriceResult {
  success,
  hold,
  invalid,
  error,
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
      return SubmitPriceResult.invalid;
    }

    final price = priceProvider();

    final submitStatus = await helpRequestNotifier.submitPriceToServer(
      HelpSubmissionData(
        product: product,
        shop: shop,
        value: price,
      ),
    );

    switch (submitStatus) {
      case SubmitPriceStatus.success:
        marketNotifier.setOfferUpdated(
          Offer(
            product: product,
            shop: shop,
          ),
        );

        helpRequestNotifier.removeRequest(
          product: product,
          shop: shop,
        );
        
        return SubmitPriceResult.success;
      case SubmitPriceStatus.hold:
        helpRequestNotifier.removeRequest(
          product: product,
          shop: shop,
        );
        return SubmitPriceResult.hold;
      case SubmitPriceStatus.error:
        return SubmitPriceResult.error;
    }
  }
}
