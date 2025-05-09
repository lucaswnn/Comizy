enum ProductMainType {
  drink,
  alcoholic,
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
}
