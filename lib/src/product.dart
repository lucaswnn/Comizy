import 'package:flutter/material.dart';

class Product {
  final String name;
  final int code;
  final String type;
  late Icon icon;

  Product(this.name, this.code, this.type) {
    switch (type) {
      case 'Tipo 1':
        icon = const Icon(Icons.one_k);
        break;
      case 'Tipo 2':
        icon = const Icon(Icons.two_k);
        break;
      case 'Tipo 3':
        icon = const Icon(Icons.three_k);
        break;
      default:
        icon = const Icon(Icons.exposure_zero);
    }
  }
}
