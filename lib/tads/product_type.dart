class ProductCategory implements Comparable<ProductCategory> {
  static final Set<ProductCategory> categories = {};

  final String label;
  final String asset;

  ProductCategory(this.label, this.asset) {
    categories.add(this);
  }

  @override
  toString() => label;

  @override
  int compareTo(ProductCategory other) => label.compareTo(other.label);
}

class ProductSubcategory implements Comparable<ProductSubcategory> {
  static final Set<ProductSubcategory> subcategories = {};

  final String label;

  ProductSubcategory(this.label) {
    subcategories.add(this);
  }

  @override
  toString() => label;

  @override
  int compareTo(ProductSubcategory other) => label.compareTo(other.label);
}

class ProductType implements Comparable<ProductType> {
  final ProductCategory mainCategory;
  final ProductSubcategory subcategory;

  const ProductType({
    required this.mainCategory,
    required this.subcategory,
  });

  @override
  int compareTo(ProductType other) {
    final mainCategoryComparison = mainCategory.compareTo(other.mainCategory);
    if (mainCategoryComparison != 0) {
      return mainCategoryComparison;
    }
    return subcategory.compareTo(other.subcategory);
  }
}
