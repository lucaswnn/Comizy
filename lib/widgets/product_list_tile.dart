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
  Icon _iconSetted = const Icon(Icons.add);
  final _addIcon = const Icon(Icons.add);
  final _removeIcon = const Icon(Icons.remove);

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
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(image: AssetImage(widget.product.asset))),
      ),
      title: Text(widget.product.name),
      subtitle: Text(widget.product.description),
      trailing: IconButton(onPressed: _onIconPressed, icon: _iconSetted),
    );
  }
}
