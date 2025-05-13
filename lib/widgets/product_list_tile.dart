import 'package:comizy/services/product_cart_change_notifier.dart';
import 'package:comizy/tads/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListTile extends StatefulWidget {
  final Product product;
  const ProductListTile({super.key, required this.product});

  @override
  State<ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  int _quantity = 0;
  final _addIcon = const Icon(Icons.add_circle_outline);
  final _removeIcon = const Icon(Icons.remove_circle_outline);
  final _clearIcon = const Icon(Icons.clear);

  void _onAddIconPressed() {
    final productCartNotifier = context.read<ProductCartChangeNotifier>();
    setState(
      () {
        _quantity++;
        productCartNotifier.addProduct(widget.product);
      },
    );
  }

  void _onRemoveIconPressed() {
    final productCartNotifier = context.read<ProductCartChangeNotifier>();
    if (_quantity > 1) {
      setState(
        () {
          _quantity--;
          productCartNotifier.removeProduct(widget.product);
        },
      );
    } else if (_quantity == 1) {
      setState(
        () {
          _quantity = 0;
          productCartNotifier.clearProduct(widget.product);
        },
      );
    }
  }

  void _onClearIconPressed() {
    final productCartNotifier = context.read<ProductCartChangeNotifier>();
    setState(
      () {
        _quantity = 0;
        productCartNotifier.clearProduct(widget.product);
      },
    );
  }

  Widget _buildButtons() {
    if (_quantity == 0) {
      return IconButton(
        onPressed: _onAddIconPressed,
        icon: _addIcon,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _onRemoveIconPressed,
          icon: _removeIcon,
        ),
        Text('$_quantity'),
        IconButton(
          onPressed: _onAddIconPressed,
          icon: _addIcon,
        ),
        IconButton(
          onPressed: _onClearIconPressed,
          icon: _clearIcon,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _quantity = context.select(
      (ProductCartChangeNotifier notifier) =>
          notifier.getProductQuantity(widget.product),
    );

    return ListTile(
      contentPadding: const EdgeInsets.all(5.0),
      leading: Material(
        elevation: 2,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(image: AssetImage(widget.product.asset))),
        ),
      ),
      title: Text(widget.product.name, style: const TextStyle(fontSize: 14)),
      subtitle: Text(widget.product.description,
          style: const TextStyle(fontSize: 12)),
      trailing: _buildButtons(),
    );
  }
}
