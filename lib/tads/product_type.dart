import 'package:flutter/material.dart';

enum ProductMainType {
  drink('Não alcoólicos', Icons.no_drinks),
  alcoholic('Alcoólicos', Icons.local_drink);

  final String label;
  final IconData icon;

  const ProductMainType(this.label, this.icon);
}

enum ProductSecondaryType {
  whiskey,
  vodka,
  softDrink,
  water,
  gin,
}

class ProductType {
  final ProductMainType mainType;
  final ProductSecondaryType secondaryType;

  const ProductType({
    required this.mainType,
    required this.secondaryType,
  });

  static const Map<ProductMainType, Set<ProductSecondaryType>> mainTypeMap = {
    ProductMainType.drink: {
      ProductSecondaryType.softDrink,
      ProductSecondaryType.water,
    },
    ProductMainType.alcoholic: {
      ProductSecondaryType.gin,
      ProductSecondaryType.vodka,
      ProductSecondaryType.whiskey,
    },
  };
}
