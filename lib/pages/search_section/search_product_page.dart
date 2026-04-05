import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/change_notifiers/product_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/tads/neighborhood.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ProductStatus {
  noNeighborhood,
  notInShowcaseAddable,
  notInShowcaseNotAddable,
  inShowcaseNoNeighborhoodToAdd,
  inShowcaseNotAddable,
  inShowcaseAddable,
  notReachable,
  error,
}

class SearchProductPage extends StatelessWidget {
  const SearchProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = context.read<ProductNotifier>().currentProduct;
    if (product == null) {
      return const InvalidRoute();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do produto ${product.name}'),
      ),
      body: const _ActionsWidget(),
    );
  }
}

class _ActionsWidget extends StatefulWidget {
  const _ActionsWidget();

  @override
  State<_ActionsWidget> createState() => _ActionsWidgetState();
}

class _ActionsWidgetState extends State<_ActionsWidget> {
  Neighborhood? _firstNeighborhoodChoice;
  Neighborhood? _neighborhoodChoice;

  late final LocationNotifier _locationNotifier;
  late final ShowcaseNotifier _showcaseNotifier;
  late final Product? _currentProduct;

  @override
  void initState() {
    super.initState();
    _locationNotifier = context.read<LocationNotifier>();
    _showcaseNotifier = context.read<ShowcaseNotifier>();
    _currentProduct = context.read<ProductNotifier>().currentProduct;

    final neighborhoods = _locationNotifier.getNearestNeighborhoods();
    if (neighborhoods.isNotEmpty) {
      _firstNeighborhoodChoice = neighborhoods.first;
      _neighborhoodChoice = _firstNeighborhoodChoice;
    }
  }

  ProductStatus _checkShowcaseAddOptions() {
    final showcase = _showcaseNotifier.showcase;
    if (showcase == null) {
      return ProductStatus.error;
    }
    final showcaseNeighborhoods = showcase
        .filterByProduct(_currentProduct!)
        .keys
        .map((i) => i.neighborhood)
        .toSet();
    final neighborhoods = _locationNotifier.getNearestNeighborhoods();
    final avaibleNeighborhoods =
        neighborhoods.difference(showcaseNeighborhoods);
    final areAvaibleNeighborhoods = avaibleNeighborhoods.isNotEmpty;
    final containsProduct = showcase.containsProduct(_currentProduct);
    final isShowcaseFull = showcase.isShowcaseFull;
    final noNeighborhood = neighborhoods.isEmpty;

    if (noNeighborhood && !containsProduct) {
      return ProductStatus.noNeighborhood;
    }

    if (!containsProduct && areAvaibleNeighborhoods) {
      if (isShowcaseFull) {
        return ProductStatus.notInShowcaseNotAddable;
      }
      return ProductStatus.notInShowcaseAddable;
    }

    if (containsProduct && !areAvaibleNeighborhoods) {
      return ProductStatus.inShowcaseNoNeighborhoodToAdd;
    }

    if (containsProduct && areAvaibleNeighborhoods) {
      if (isShowcaseFull) {
        return ProductStatus.inShowcaseAddable;
      }
      return ProductStatus.inShowcaseNotAddable;
    }

    return ProductStatus.notReachable;
  }

  Widget _buildActionsWidget(ProductStatus showcaseAddOption) {
    switch (showcaseAddOption) {
      case ProductStatus.inShowcaseAddable:
      case ProductStatus.notInShowcaseAddable:
        {
          final showcaseNeighborhoods = _showcaseNotifier.showcase!
              .filterByProduct(_currentProduct!)
              .keys
              .map((i) => i.neighborhood)
              .toSet();

          final neighborhoodOptions = _locationNotifier
              .getNearestNeighborhoods()
              .difference(showcaseNeighborhoods);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownMenu<Neighborhood>(
                initialSelection: _firstNeighborhoodChoice,
                dropdownMenuEntries: neighborhoodOptions
                    .map((n) => DropdownMenuEntry<Neighborhood>(
                        value: n, label: n.name))
                    .toList(),
                onSelected: (v) => setState(
                  () => _neighborhoodChoice = v,
                ),
              ),
              ElevatedButton(
                  onPressed: _neighborhoodChoice != null
                      ? () {
                          _showcaseNotifier.addShowcaseItem(ShowcaseItem(
                              product: _currentProduct!,
                              neighborhood: _neighborhoodChoice!));
                          NavigationHelper.pop();
                        }
                      : null,
                  child: const Text('Adicionar'))
            ],
          );
        }
      case ProductStatus.noNeighborhood:
      case ProductStatus.notInShowcaseNotAddable:
      case ProductStatus.inShowcaseNoNeighborhoodToAdd:
      case ProductStatus.inShowcaseNotAddable:
      case ProductStatus.notReachable:
        return const EmptyWidget();
      case ProductStatus.error:
        return ElevatedButton(
          onPressed: () {
            NavigationHelper.pushNamedAndClearStack(AppRoutes.landingPage);
          },
          child: const Text('Retornar'),
        );
    }
  }

  String _message(ProductStatus showcaseAddOption) {
    switch (showcaseAddOption) {
      case ProductStatus.notInShowcaseAddable:
        return 'Para mais detalhes, adicione este produto na vitrine';
      case ProductStatus.inShowcaseAddable:
        return 'Para mais detalhes deste produto em outros bairros, adicione-o na vitrine';
      case ProductStatus.noNeighborhood:
        return 'Parece que a localização inserida não possui bairros cadastrados na plataforma';
      case ProductStatus.notInShowcaseNotAddable:
        return 'Ops, não encontramos este produto na localização atual';
      case ProductStatus.inShowcaseNoNeighborhoodToAdd:
        return 'Detalhes do produto';
      case ProductStatus.inShowcaseNotAddable:
        return 'Detalhes do produto';
      case ProductStatus.notReachable:
        return 'Algo deu errado';
      case ProductStatus.error:
        return 'Erro de conexão. Faça login novamente.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentProduct == null) {
      return const EmptyWidget();
    }

    final showcaseAddOption = _checkShowcaseAddOptions();
    final String message = _message(showcaseAddOption);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(message),
        _buildActionsWidget(showcaseAddOption),
      ],
    );
  }
}
