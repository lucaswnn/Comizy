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
  bool _isAdded = false;
  Icon _iconSetted = const Icon(Icons.add_circle_outline);
  final _addIcon = const Icon(Icons.add_circle_outline);
  final _removeIcon = const Icon(Icons.remove_circle_outline);

  void _onIconPressed() {
    setState(
      () {
        final productCartNotifier = context.read<ProductCartChangeNotifier>();
        if (_isAdded) {
          productCartNotifier.removeProduct(widget.product);
          _iconSetted = _addIcon;
        } else {
          productCartNotifier.addProduct(widget.product);
          _iconSetted = _removeIcon;
        }
        _isAdded = !_isAdded;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      trailing: IconButton(onPressed: _onIconPressed, icon: _iconSetted),
    );
  }
}
