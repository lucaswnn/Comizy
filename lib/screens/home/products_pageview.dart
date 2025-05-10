import 'package:comizy/tads/product_type.dart';
import 'package:comizy/utils/mvp_database.dart';
import 'package:comizy/widgets/product_list_tile.dart';
import 'package:comizy/widgets/product_type_dropdown_button.dart';
import 'package:flutter/material.dart';

class ProductsPageView extends StatelessWidget {
  const ProductsPageView({super.key});

  final List<ProductMainType> _productTypeDropdownButtonItems =
      ProductMainType.values;

  void _onProductTypeChanged(ProductMainType type) {
    print(type.label);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ProductTypeDropdownButton(
              mainTypes: _productTypeDropdownButtonItems,
              onChanged: _onProductTypeChanged,
              firstSelected: _productTypeDropdownButtonItems.first,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: mvpProducts.length,
              itemBuilder: (_, index) {
                return ProductListTile(product: mvpProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
