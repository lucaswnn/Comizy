import 'package:flutter/material.dart';

class BasicMarketItem {
  final String name;
  final String type;
  final int id;
  double? rating;
  late IconData iconData;

  BasicMarketItem({required this.name, required this.type, required this.id});
}