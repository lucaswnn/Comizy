import 'package:flutter/material.dart';

enum ProductCategory {
  drink('Não alcoólicos', Icons.no_drinks),
  alcoholic('Alcoólicos', Icons.local_drink);

  final String label;
  final IconData icon;

  const ProductCategory(this.label, this.icon);

  @override
  toString() => label;
}

enum ProductSubcategory {
  whiskey('Whisky'),
  vodka('Vodka'),
  softDrink('Refrigerante'),
  water('Água'),
  gin('Gin');

  final String label;

  const ProductSubcategory(this.label);

  @override
  toString() => label;
}

class ProductType {
  final ProductCategory mainCategory;
  final ProductSubcategory subcategory;

  const ProductType({
    required this.mainCategory,
    required this.subcategory,
  });

  static const Map<ProductCategory, Set<ProductSubcategory>> mainTypeMap = {
    ProductCategory.drink: {
      ProductSubcategory.softDrink,
      ProductSubcategory.water,
    },
    ProductCategory.alcoholic: {
      ProductSubcategory.gin,
      ProductSubcategory.vodka,
      ProductSubcategory.whiskey,
    },
  };
}
