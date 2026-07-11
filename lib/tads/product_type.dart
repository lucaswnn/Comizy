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

class ProductVariation implements Comparable<ProductVariation> {
  final int? id;
  final String? description;

  const ProductVariation({
    this.id,
    this.description,
  });

  bool get isDefined {
    final hasDescription = (description ?? '').trim().isNotEmpty;
    return id != null || hasDescription;
  }

  String get label {
    final text = (description ?? '').trim();
    if (text.isEmpty) {
      return 'Sem variacao';
    }
    return text;
  }

  @override
  String toString() => label;

  @override
  int compareTo(ProductVariation other) {
    return label.compareTo(other.label);
  }
}

class ProductType implements Comparable<ProductType> {
  final ProductCategory mainCategory;
  final ProductSubcategory subcategory;
  final ProductVariation? productVariation;

  const ProductType({
    required this.mainCategory,
    required this.subcategory,
    this.productVariation,
  });

  @override
  int compareTo(ProductType other) {
    final mainCategoryComparison = mainCategory.compareTo(other.mainCategory);
    if (mainCategoryComparison != 0) {
      return mainCategoryComparison;
    }
    final subcategoryComparison = subcategory.compareTo(other.subcategory);
    if (subcategoryComparison != 0) {
      return subcategoryComparison;
    }

    final currentVariation = productVariation;
    final otherVariation = other.productVariation;
    if (currentVariation == null && otherVariation == null) {
      return 0;
    }
    if (currentVariation == null) {
      return -1;
    }
    if (otherVariation == null) {
      return 1;
    }
    return currentVariation.compareTo(otherVariation);
  }
}
