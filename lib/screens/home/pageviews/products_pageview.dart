import 'package:comizy/services/change_notifiers/market_change_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_change_notifier.dart';
import 'package:comizy/tads/market.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/widgets/product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPageView extends StatefulWidget {
  const ProductsPageView({super.key});

  @override
  State<ProductsPageView> createState() => _ProductsPageViewState();
}

class _ProductsPageViewState extends State<ProductsPageView> {
  late final Market _market;
  late final Showcase _showcase;

  @override
  void initState() {
    _market = context.read<MarketChangeNotifier>().market;
    _showcase = context.read<ShowcaseChangeNotifier>().showcase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _showcase.productCount,
            itemBuilder: (_, index) => SizedBox(
              width: 200,
              child: Center(child: ProductListTile(product: _showcase[index])),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _market.products.length,
          itemBuilder: (_, index) =>
              ProductListTile(product: _market.products[index]),
        ),
      ],
    );
  }
}
