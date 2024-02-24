import 'package:comizy/src/tad/product.dart';
import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';

class Shop {
  final int id;
  final String name;
  final String address;
  final LatLng location;
  final String type;
  List<Product> products = [];
  double? rating;
  late IconData iconData;

  Shop(this.id, this.name, this.address, this.location, this.type) {
    _setCategoryIcon();
  }

  void _setCategoryIcon() {
    switch (type) {
      case 'Supermercado':
        iconData = Icons.local_grocery_store;
        break;
      case 'Posto':
        iconData = Icons.local_gas_station;
        break;
      case 'Limpeza':
        iconData = Icons.cleaning_services;
        break;
      case 'Higiene':
        iconData = Icons.clean_hands;
        break;
      case 'Combustivel':
        iconData = Icons.gas_meter;
        break;
      default:
        iconData = Icons.exposure_zero;
    }
  }

  static List<Shop> shopList(List<Map<String, dynamic>> list) {
    List<Shop> shops = [];
    for (Map<String, dynamic> shop in list) {
      shops.add(
        Shop(
          shop['ID_LOJA'],
          shop['NOME_LOJA'],
          shop['ENDERECO_LOJA'],
          LatLng(
            shop['LATITUDE_LOJA'].toDouble(),
            shop['LONGITUDE_LOJA'].toDouble(),
          ),
          shop['CATEGORIA_LOJA'],
        ),
      );

      if (shop.containsKey('VALOR_VENDA')) {
        shops.last.products.add(
          Product(shop['NOME_PRODUTO'], shop['ID_PRODUTO'],
              shop['CATEGORIA_PRODUTO']),
        );

        shops.last.products.first.value = shop['VALOR_VENDA'];
      }

      shops.last.rating = shop['NOTA_LOJA'];
    }
    return shops;
  }

  void addProduct(Product product) {
    products.add(product);
  }
}
