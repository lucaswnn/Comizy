import 'dart:async';
import 'dart:math';

import 'package:comizy/utils/mvp_database.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/widgets/layout_builder_wrapper.dart';
import 'package:comizy/widgets/product_list_tile.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<ProductListTile> _suggestions = [];
  final _textController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onSearchChanged);
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
        _suggestions = mvpProducts
            .where((product) =>
                product.name.toLowerCase().contains(query) && query.isNotEmpty)
            .map((filteredProduct) => ProductListTile(product: filteredProduct))
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
      itemBuilder: (_, index) => _suggestions[index],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWrapper(
      child: Container(
        color: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primaryColor,
            title: TextField(
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                  hintText: 'Digite o item que você procura',
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              controller: _textController,
            ),
          ),
          body: _buildResults(),
        ),
      ),
    );
  }
}
