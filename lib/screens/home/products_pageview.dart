import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/product_type.dart';
import 'package:comizy/utils/mvp_database.dart';
import 'package:comizy/widgets/product_list_tile.dart';
import 'package:comizy/widgets/product_type_dropdown_button.dart';
import 'package:flutter/material.dart';

class ProductsPageView extends StatefulWidget {
  const ProductsPageView({super.key});

  @override
  State<ProductsPageView> createState() => _ProductsPageViewState();
}

class _ProductsPageViewState extends State<ProductsPageView> {
  late List<Product> _currentProducts;

  final List<ProductMainType> _productTypeDropdownButtonItems =
      ProductMainType.values;

  late ProductMainType _currentMainType;

  @override
  void initState() {
    super.initState();
    _currentMainType = _productTypeDropdownButtonItems.first;
    _currentProducts = mvpProducts
        .where((product) => product.productType.mainType == _currentMainType)
        .toList();
  }

  void _onProductTypeChanged(ProductMainType type) => setState(
        () {
          _currentProducts = mvpProducts
              .where((product) => product.productType.mainType == type)
              .toList();
          _currentMainType = type;
        },
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ProductTypeDropdownButton(
                mainTypes: _productTypeDropdownButtonItems,
                onChanged: _onProductTypeChanged,
                firstSelected: _currentMainType,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _currentProducts.length,
              itemBuilder: (_, index) {
                return ProductListTile(
                    key: ValueKey(_currentProducts[index].name),
                    product: _currentProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
