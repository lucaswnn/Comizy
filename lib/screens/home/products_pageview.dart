import 'package:comizy/utils/mvp_database.dart';
import 'package:comizy/widgets/product_list_tile.dart';
import 'package:flutter/material.dart';

class ProductsPageView extends StatelessWidget {
  const ProductsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mvpProducts.length,
      itemBuilder: (_, index) {
        return ProductListTile(product: mvpProducts[index]);
      },
    );
  }
}
