import 'package:comizy/tads/product.dart';

class Showcase{
  final List<Product> _products = [];
  
  List<Product> get products => _products;
  void addProduct(Product product) {
    _products.add(product);
  }

  void removeProduct(Product product) {
    _products.remove(product);
  }

  void clearShowcase() {
    _products.clear();
  }

  void addProducts(List<Product> products) {
    _products.addAll(products);
  }

  int get productCount => _products.length;

  bool containsProduct(Product product) {
    return _products.contains(product);
  }
}