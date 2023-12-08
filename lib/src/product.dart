import 'package:flutter/material.dart';

class Product {
  final String name;
  final int id;
  final String type;
  late IconData iconData;

  Product(this.name, this.id, this.type) {
    switch (type) {
      case 'Tipo 1':
        iconData = Icons.one_k;
        break;
      case 'Tipo 2':
        iconData = Icons.two_k;
        break;
      case 'Tipo 3':
        iconData = Icons.three_k;
        break;
      default:
        iconData = Icons.exposure_zero;
    }
  }
}
