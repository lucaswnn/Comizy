import 'package:flutter/material.dart';

class BasicMarketItem {
  final String name;
  late Category category;
  late SubCategory subCategory;
  final int id;
  double? rating;

  BasicMarketItem({
    required this.name,
    required String type,
    String subtype = '',
    required this.id,
  })  : category = Category(type: type),
        subCategory = SubCategory(subtype: subtype);
}

class Category {
  final String type;
  late IconData iconData;
  late Color color;

  Category({
    required this.type,
  }) {
    _setIcon();
  }

  void _setIcon() {
    const Map<String, CategoryTuple> categories = {
      'Bebida': CategoryTuple(Icons.liquor, Colors.blue),
      'Comida': CategoryTuple(Icons.fastfood, Colors.yellow),
      'Limpeza': CategoryTuple(Icons.cleaning_services, Colors.green),
      'Higiene': CategoryTuple(Icons.clean_hands, Colors.green),
      'Supermercado': CategoryTuple(Icons.local_grocery_store, Colors.grey),
      'Posto': CategoryTuple(Icons.local_gas_station, Colors.grey),
      'Combustivel': CategoryTuple(Icons.gas_meter, Colors.grey),
      'Mercearia': CategoryTuple(Icons.shopping_basket, Colors.grey),
    };

    if (categories.containsKey(type)) {
      iconData = categories[type]!.iconData;
      color = categories[type]!.color;
    } else {
      iconData = Icons.exposure_zero;
      color = Colors.grey;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;
}

class SubCategory {
  final String subtype;
  late IconData iconData;
  late Color color;

  SubCategory({this.subtype = ''}) {
    _setIcon();
  }

  void _setIcon() {
    const Map<String, CategoryTuple> subCategories = {
      'Cerveja': CategoryTuple(Icons.liquor, Colors.yellow),
      'Refrigerante':
          CategoryTuple(Icons.liquor, Color.fromARGB(255, 12, 68, 255)),
      'Energético': CategoryTuple(Icons.liquor, Colors.orange),
    };

    if (subCategories.containsKey(subtype)) {
      iconData = subCategories[subtype]!.iconData;
      color = subCategories[subtype]!.color;
    } else {
      iconData = Icons.exposure_zero;
      color = Colors.grey;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategory &&
          runtimeType == other.runtimeType &&
          subtype == other.subtype;

  @override
  int get hashCode => subtype.hashCode;
}

class CategoryTuple<IconData, Color> {
  final IconData iconData;
  final Color color;

  const CategoryTuple(this.iconData, this.color);
}
