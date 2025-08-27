import 'package:comizy/services/change_notifiers/showcase_change_notifier.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/utils/test_database.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseFirstProductsScreen extends StatefulWidget {
  const ChooseFirstProductsScreen({super.key});

  @override
  State<ChooseFirstProductsScreen> createState() =>
      _ChooseFirstProductsScreenState();
}

class _ChooseFirstProductsScreenState extends State<ChooseFirstProductsScreen> {
  Product? product1;
  Product? product2;

  Future<void> _chooseProduct(int slot) async {
    final result = await showSearch<Product?>(
      context: context,
      delegate: ProductSearchDelegate(),
    );

    if (result != null) {
      setState(() {
        if (slot == 1) {
          product1 = result;
        } else {
          product2 = result;
        }
      });
    }
  }

  bool get _canProceed => product1 != null && product2 != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escolha seus produtos")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Escolha 2 produtos para acompanhar os preços. "
              "Você poderá trocá-los depois de 1 semana.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _productContainer(1, product1),
                _productContainer(2, product2),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _canProceed
                  ? () {
                      final showcaseNotifier =
                          context.read<ShowcaseChangeNotifier>();
                      showcaseNotifier.clearShowcase();
                      showcaseNotifier.addProduct(product1!);
                      showcaseNotifier.addProduct(product2!);
                      NavigationHelper.pushReplacementNamed(AppRoutes.homePage);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Prosseguir"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productContainer(int slot, Product? product) {
    return GestureDetector(
      onTap: () => _chooseProduct(slot),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: product == null
              ? const Icon(Icons.add, size: 40, color: Colors.grey)
              : Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
        ),
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final List<Product> _products = testProducts;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          title: Text(product.name),
          onTap: () => close(context, product),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(product.name),
          onTap: () {
            close(context, product);
          },
        );
      },
    );
  }
}
