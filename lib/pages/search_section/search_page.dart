import 'dart:async';
import 'dart:math';

import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/product_notifier.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> _suggestions = [];
  List<Product> _options = [];
  final _textController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _options = context.read<MarketNotifier>().market.products.toList();
    _textController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    super.dispose();
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _textController.dispose();
  }

  Future<void> _onSearchChanged() async {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    final query = _textController.text.toLowerCase();
    if (query == '') {
      setState(() => _suggestions.clear());
      return;
    }

    _debounce = Timer(
        const Duration(milliseconds: 500), () => _filterSuggestions(query));
  }

  void _filterSuggestions(String query) => setState(() {
        _suggestions = _options
            .where((product) =>
                product.name.toLowerCase().contains(query) && query.isNotEmpty)
            .toList();
      });

  Widget _buildResults() {
    if (_suggestions.isEmpty && _textController.text != '') {
      return const Center(
        child: Text('ops... parece que o item não existe :('),
      );
    }

    return ListView.builder(
      itemCount: min(_suggestions.length, 10),
      itemBuilder: (_, index) {
        return ListTile(
          title: Text(_suggestions[index].name),
          onTap: () {
            context.read<ProductNotifier>().currentProduct =
                _suggestions[index];
            NavigationHelper.pushNamed(AppRoutes.searchProductPage);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Digite o item que você procura',
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
          ),
          controller: _textController,
        ),
      ),
      body: _buildResults(),
    );
  }
}
