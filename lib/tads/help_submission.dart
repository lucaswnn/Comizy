import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';

class HelpSubmissionData {
  final Product product;
  final Shop shop;
  final double value;

  const HelpSubmissionData({
    required this.product,
    required this.shop,
    required this.value,
  });
}
