import 'package:comizy/tads/product.dart';
import 'package:flutter/material.dart';

class ProductCartChangeNotifier extends ChangeNotifier{
  final Set<Product> _products = {};
  Set<Product> get products => _products;

  void addProduct(Product product){
    _products.add(product);
  }

  void removeProduct(Product product){
    _products.remove(product);
  }
}