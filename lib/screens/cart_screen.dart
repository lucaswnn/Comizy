import 'package:comizy/services/database_dao.dart';
import 'package:comizy/services/product_cart_change_notifier.dart';
import 'package:comizy/services/user_change_notifier.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/user.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/widgets/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<Product, int> _cart = {};
  late final User _user;

  Widget _contentBuilder() {
    final products = _cart.keys.toList();

    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.remove_shopping_cart,
              size: 50,
            ),
            SizedBox(height: 20),
            Text(
              'Carrinho vazio\nAdicione produtos em seu carrinho!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (_, index) =>
                ProductListTile(product: products[index]),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shadowColor: AppColors.secondaryColor,
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryColor,
              elevation: 3,
            ),
            onPressed: _onSubmitButtonPressed,
            child: const Text('Enviar orçamento'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _onSubmitButtonPressed() async => DatabaseDAO.sendCartData(
        _user,
        _cart,
      );

  @override
  void initState() {
    super.initState();
    _user = context.read<UserChangeNotifier>().user!;
  }

  @override
  Widget build(BuildContext context) {
    _cart = context.watch<ProductCartChangeNotifier>().products;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Meu carrinho',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _contentBuilder(),
      ),
    );
  }
}
