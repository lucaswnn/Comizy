import 'package:comizy/tads/product_type.dart';

class Product implements Comparable<Product> {
  final int id;
  final String name;
  final String description;
  final ProductType productType;
  final String asset;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.productType,
    required this.asset,
  });

  factory Product.fromJSON(Map<String, dynamic> productData) {
    final int productId = productData['product_id'];
    final String productName = productData['product_name'];
    final String productDescription = productData['product_description'] ?? '';
    final String productAsset = productData['product_asset'] ?? '';
    final Map<String, dynamic> productCategoryData =
        productData['product_categories'];
    final String productCategory = productCategoryData['product_category_name'];
    final String productCategoryAsset =
        productCategoryData['product_category_asset'] ?? '';
    final Map<String, dynamic> productSubcategoryData =
        productData['product_subcategories'];
    final String productSubcategory =
        productSubcategoryData['product_subcategory_name'];

    final rawVariationData = productData['product_variations'];
    ProductVariation? productVariation;
    if (rawVariationData is Map<String, dynamic>) {
      final variationId = rawVariationData['product_variation_id'];
      final variationDescription =
          rawVariationData['product_variation_description'];
      productVariation = ProductVariation(
        id: variationId is int ? variationId : null,
        description:
            variationDescription is String ? variationDescription : null,
      );
      if (!productVariation.isDefined) {
        productVariation = null;
      }
    }

    final productType = ProductType(
        mainCategory: ProductCategory(productCategory, productCategoryAsset),
        subcategory: ProductSubcategory(productSubcategory),
        productVariation: productVariation);

    return Product(
      id: productId,
      name: productName,
      description: productDescription,
      productType: productType,
      asset: productAsset,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name);

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => name;

  @override
  int compareTo(Product other) {
    return name.compareTo(other.name);
  }

  static int compareByType(Product a, Product b) {
    final typeComparison = a.productType.compareTo(b.productType);
    if (typeComparison != 0) {
      return typeComparison;
    }
    return a.name.compareTo(b.name);
  }
}
