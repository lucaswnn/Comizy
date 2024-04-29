import 'package:flutter/material.dart';

class BasicMarketItem {
  final String name;
  late Category category;
  final int id;
  double? rating;

  BasicMarketItem({required this.name, required type, required this.id}) {
    category = Category(type: type);
  }
}

class Category {
  final String type;
  late IconData iconData;
  late Color color;
  Category({required this.type}) {
    _setCategoryIcon();
  }

  void _setCategoryIcon() {
    Map<String, CategoryTuple> categories = {
      'Bebida': CategoryTuple(
        Icons.liquor,
        Colors.blue,
      ),
      'Comida': CategoryTuple(
        Icons.fastfood,
        Colors.yellow,
      ),
      'Limpeza': CategoryTuple(
        Icons.cleaning_services,
        Colors.green,
      ),
      'Higiene': CategoryTuple(
        Icons.clean_hands,
        Colors.green,
      ),
      'Supermercado': CategoryTuple(
        Icons.local_grocery_store,
        Colors.grey,
      ),
      'Posto': CategoryTuple(
        Icons.local_gas_station,
        Colors.grey,
      ),
      'Combustivel': CategoryTuple(
        Icons.gas_meter,
        Colors.grey,
      ),
      'Mercearia': CategoryTuple(
        Icons.shopping_basket,
        Colors.grey,
      ),
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

class CategoryTuple<IconData, Color> {
  final IconData iconData;
  final Color color;

  CategoryTuple(this.iconData, this.color);
}
