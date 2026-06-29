import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/change_notifiers/product_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/services/shared_preferenes/app_preferences.dart';
import 'package:comizy/tads/neighborhood.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/reset_loadable_notifiers.dart';
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

  ProductStatus _checkShowcaseAddOptions({
    required ShowcaseNotifier showcaseNotifier,
    required LocationNotifier locationNotifier,
    required Product? currentProduct,
  }) {
    final showcase = showcaseNotifier.showcase;
    if (showcase == null) {
      return ProductStatus.error;
    }

    final showcaseNeighborhoods = showcase
        .filterByProduct(currentProduct!)
        .keys
        .map((i) => i.neighborhood)
        .toSet();
    final neighborhoods = locationNotifier.getNearestNeighborhoods();
    final avaibleNeighborhoods =
        neighborhoods?.difference(showcaseNeighborhoods) ?? {};
    final areAvaibleNeighborhoods = avaibleNeighborhoods.isNotEmpty;
    final containsProduct = showcase.containsProduct(currentProduct);
    final isShowcaseFull = showcase.isShowcaseFull;
    final noNeighborhood = neighborhoods?.isEmpty ?? true;

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

  Widget _buildActionsWidget({
    required ProductStatus showcaseAddOption,
    required ShowcaseNotifier showcaseNotifier,
    required LocationNotifier locationNotifier,
    required Product? currentProduct,
  }) {
    switch (showcaseAddOption) {
      case ProductStatus.inShowcaseAddable:
      case ProductStatus.notInShowcaseAddable:
        {
          final showcaseNeighborhoods = showcaseNotifier.showcase!
              .filterByProduct(currentProduct!)
              .keys
              .map((i) => i.neighborhood)
              .toSet();

          final neighborhoodOptions = locationNotifier
                  .getNearestNeighborhoods()
                  ?.difference(showcaseNeighborhoods) ??
              {};

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
                      ? () async {
                          final result = await showcaseNotifier.addShowcaseItem(
                            ShowcaseItem(
                              product: currentProduct,
                              neighborhood: _neighborhoodChoice!,
                            ),
                          );
                          if (result == ShowcaseAddItemStatus.success) {
                            NavigationHelper.pop();
                          } else {
                          }
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
          onPressed: () async {
            resetLoadableNotifiers(context);
            final authService = AuthService.instance;
            await authService.logout();
            await AppPreferences.resetPreferences();
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
    final locationNotifier = context.read<LocationNotifier>();
    final showcaseNotifier = context.read<ShowcaseNotifier>();
    final currentProduct = context.read<ProductNotifier>().currentProduct;

    final neighborhoods = locationNotifier.getNearestNeighborhoods();
    if (neighborhoods != null && neighborhoods.isNotEmpty) {
      _firstNeighborhoodChoice = neighborhoods.first;
      _neighborhoodChoice = _firstNeighborhoodChoice;
    }

    if (currentProduct == null) {
      return const EmptyWidget();
    }

    final showcaseAddOption = _checkShowcaseAddOptions(
      showcaseNotifier: showcaseNotifier,
      locationNotifier: locationNotifier,
      currentProduct: currentProduct,
    );
    final String message = _message(showcaseAddOption);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(message),
        _buildActionsWidget(
          showcaseAddOption: showcaseAddOption,
          showcaseNotifier: showcaseNotifier,
          locationNotifier: locationNotifier,
          currentProduct: currentProduct,
        ),
      ],
    );
  }
}
