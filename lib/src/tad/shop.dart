import 'package:comizy/src/tad/basic_market_item.dart';
import 'package:comizy/src/tad/product.dart';

import 'package:latlong2/latlong.dart';

class Shop extends BasicMarketItem {
  final String address;
  final LatLng location;
  List<Product> products = [];

  Shop(
      {required int id,
      required String name,
      required this.address,
      required this.location,
      required String type})
      : super(name: name, type: type, id: id);

  static List<Shop> shopList(List<Map<String, dynamic>> list) {
    List<Shop> shops = [];
    for (Map<String, dynamic> shop in list) {
      shops.add(
        Shop(
          id: shop['ID_LOJA'],
          name: shop['NOME_LOJA'],
          address: shop['ENDERECO_LOJA'],
          location: LatLng(
            shop['LATITUDE_LOJA'].toDouble(),
            shop['LONGITUDE_LOJA'].toDouble(),
          ),
          type: shop['CATEGORIA_LOJA'],
        ),
      );

      if (shop.containsKey('VALOR_VENDA')) {
        shops.last.products.add(
          Product(
            name: shop['NOME_PRODUTO'],
            id: shop['ID_PRODUTO'],
            type: shop['CATEGORIA_PRODUTO'],
          ),
        );
        shops.last.products.first.value = shop['VALOR_VENDA'].toDouble();
      }

      shops.last.rating = shop['NOTA_LOJA'].toDouble();
    }
    return shops;
  }
}
