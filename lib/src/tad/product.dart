import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:comizy/src/tad/shop.dart';

class Product extends BasicMarketItem {
  List<Shop> shops = [];
  double? value;

  static double? minimumValue;
  static double? maximumValue;
  static Shop? minimumValueShop;

  Product({
    required int id,
    required String name,
    required String type,
  }) : super(id: id, name: name, type: type);

  static List<Product> productList(List<Map<String, dynamic>> list) {
    List<Product> products = [];
    for (Map<String, dynamic> product in list) {
      products.add(
        Product(
          name: product['NOME_PRODUTO'],
          id: product['ID_PRODUTO'],
          type: product['CATEGORIA_PRODUTO'],
        ),
      );

      product.containsKey('VALOR_VENDA')
          ? products.last.value = product['VALOR_VENDA'].toDouble()
          : null;

      product.containsKey('NOTA_VENDA')
          ? products.last.rating = product['NOTA_VENDA'].toDouble()
          : null;
    }
    return products;
  }
}
