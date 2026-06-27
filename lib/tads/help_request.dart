import 'package:comizy/tads/neighborhood.dart';
import 'package:comizy/tads/product.dart';

class HelpRequest {
  final Product product;
  final Neighborhood neighborhood;
  final int numberOfOrderers;

  const HelpRequest({
    required this.product,
    required this.neighborhood,
    required this.numberOfOrderers,
  });
}
