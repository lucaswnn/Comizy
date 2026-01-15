import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/user.dart';

class HelpRequest {
  final Product product;
  final OtherUser mainOrderer;
  final int numberOfOrderes;
  
  const HelpRequest({
    required this.product,
    required this.mainOrderer,
    required this.numberOfOrderes,
  });
}