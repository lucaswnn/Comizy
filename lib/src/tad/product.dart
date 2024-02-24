import 'package:comizy/src/tad/shop.dart';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final int id;
  final String type;
  late IconData iconData;
  List<Shop> shops = [];
  double? value;
  double? rating;

  Product(this.name, this.id, this.type) {
    _setCategoryIcon();
  }

  void _setCategoryIcon() {
    switch (type) {
      case 'Bebida':
        iconData = Icons.liquor;
        break;
      case 'Comida':
        iconData = Icons.fastfood;
        break;
      case 'Limpeza':
        iconData = Icons.cleaning_services;
        break;
      case 'Higiene':
        iconData = Icons.clean_hands;
        break;
      case 'Combustivel':
        iconData = Icons.local_gas_station;
        break;
      default:
        iconData = Icons.exposure_zero;
    }
  }

  static List<Product> productList(List<Map<String, dynamic>> list) {
    List<Product> products = [];
    for (Map<String, dynamic> product in list) {
      products.add(
        Product(
          product['NOME_PRODUTO'],
          product['ID_PRODUTO'],
          product['CATEGORIA_PRODUTO'],
        ),
      );

      product.containsKey('VALOR_VENDA')
          ? products.last.value = product['VALOR_VENDA']
          : null;

      product.containsKey('NOTA_VENDA')
          ? products.last.rating = product['NOTA_VENDA']
          : null;
    }
    return products;
  }

  void addShop(Shop shop) {
    shops.add(shop);
  }
}
