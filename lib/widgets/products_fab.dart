import 'package:comizy/services/product_cart_change_notifier.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsFAB extends StatefulWidget {
  const ProductsFAB({super.key});

  @override
  State<ProductsFAB> createState() => _ProductsFABState();
}

class _ProductsFABState extends State<ProductsFAB> {
  int _cartSize = 0;

  void _onPressed() {}

  @override
  Widget build(BuildContext context) {
    _cartSize = context.watch<ProductCartChangeNotifier>().products.length;

    return Badge(
      label: Text(_cartSize.toString()),
      child: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primaryColor,
        onPressed: _onPressed,
        child: const Icon(
          Icons.shopping_basket,
          color: Colors.white,
        ),
      ),
    );
  }
}
