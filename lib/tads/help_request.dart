import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/app_user.dart';

class HelpRequest {
  final Product product;
  final AppOtherUser mainOrderer;
  final int numberOfOrderes;

  const HelpRequest({
    required this.product,
    required this.mainOrderer,
    required this.numberOfOrderes,
  });
}
