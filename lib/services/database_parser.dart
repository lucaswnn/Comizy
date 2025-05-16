import 'dart:convert';

import 'package:comizy/tads/product.dart';

class DatabaseParser {
  const DatabaseParser._();

  static String cartToJson(Map<Product, int> products) {
    return jsonEncode(
      products.entries
          .map(
            (entry) => {
              'name': entry.key.name,
              'description': entry.key.description,
              'quantity': entry.value,
            },
          )
          .toList(),
    );
  }
}
