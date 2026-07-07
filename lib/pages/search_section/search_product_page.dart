import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/services/change_notifiers/async_action_notifier.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/change_notifiers/product_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/services/command/add_showcase_item_command.dart';
import 'package:comizy/services/shared_preferenes/app_preferences.dart';
import 'package:comizy/tads/neighborhood.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/reset_loadable_notifiers.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/widgets/async_elevated_button.dart';
import 'package:comizy/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comizy/values/app_colors.dart';

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
        title: Text('Produto: ${product.name}'),
      ),
      body: const SafeArea(
        child: Center(
          child: _ActionsWidget(),
        ),
      ),
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
        return ProductStatus.inShowcaseNotAddable;
      }
      return ProductStatus.inShowcaseAddable;
    }

    return ProductStatus.notReachable;
  }

  Widget? _buildActionsWidget({
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
          _firstNeighborhoodChoice =
              neighborhoodOptions.isNotEmpty ? neighborhoodOptions.first : null;
          _neighborhoodChoice = _firstNeighborhoodChoice;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: DropdownMenu<Neighborhood>(
                  initialSelection: _firstNeighborhoodChoice,
                  dropdownMenuEntries: neighborhoodOptions
                      .map((n) => DropdownMenuEntry<Neighborhood>(
                          value: n, label: n.name))
                      .toList(),
                  onSelected: (v) => setState(() => _neighborhoodChoice = v),
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    suffixIconColor: AppColors.tertiary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ChangeNotifierProvider(
                create: (_) => AsyncActionNotifier<ShowcaseAddItemStatus>(),
                child: Consumer<AsyncActionNotifier<ShowcaseAddItemStatus>>(
                  builder: (context, asyncActionNotifier, _) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        bool mustShowDialog = false;
                        String dialogTitle = '';
                        String dialogContent = '';
                        switch (asyncActionNotifier.result) {
                          case ShowcaseAddItemStatus.success:
                            NavigationHelper.pop();
                            break;

                          case ShowcaseAddItemStatus.alreadyExists:
                            mustShowDialog = true;
                            dialogTitle = 'Produto já existe na vitrine';
                            dialogContent =
                                'Este produto já está sendo acompanhado na sua vitrine.';
                            break;
                          case ShowcaseAddItemStatus.limitReached:
                            mustShowDialog = true;
                            dialogTitle = 'Limite de produtos atingido';
                            dialogContent =
                                'Você atingiu o limite de produtos na vitrine.';
                            break;
                          case ShowcaseAddItemStatus.error:
                            mustShowDialog = true;
                            dialogTitle = 'Erro ao adicionar produto';
                            dialogContent =
                                'Ocorreu um erro ao tentar adicionar o produto na vitrine.';
                            break;
                          case null:
                            break;
                        }

                        if (mustShowDialog) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(dialogTitle),
                                content: Text(dialogContent),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    );

                    final showcaseItem = ShowcaseItem(
                      product: currentProduct,
                      neighborhood: _neighborhoodChoice!,
                    );

                    return AsyncElevatedButton<ShowcaseAddItemStatus>(
                      notifier: asyncActionNotifier,
                      command: _neighborhoodChoice != null
                          ? AddShowcaseItemCommand(
                              showcaseNotifier: showcaseNotifier,
                              showcaseItem: showcaseItem,
                            )
                          : null,
                      child: const Text('Adicionar na vitrine'),
                    );
                  },
                ),
              ),
            ],
          );
        }
      case ProductStatus.noNeighborhood:
      case ProductStatus.notInShowcaseNotAddable:
      case ProductStatus.inShowcaseNoNeighborhoodToAdd:
      case ProductStatus.inShowcaseNotAddable:
      case ProductStatus.notReachable:
        return null;
      case ProductStatus.error:
        return ElevatedButton(
          onPressed: () async {
            resetLoadableNotifiers(context);
            final authService = AuthService.instance;
            await authService.logout();
            await AppPreferences.resetPreferences();
            NavigationHelper.pushNamedAndClearStack(AppRoutes.landingPage);
          },
          child: const Text('Voltar ao início'),
        );
    }
  }

  String _message(ProductStatus showcaseAddOption) {
    switch (showcaseAddOption) {
      case ProductStatus.notInShowcaseAddable:
        return 'Adicione este produto na sua vitrine para acompanhar os preços.';
      case ProductStatus.inShowcaseAddable:
        return 'Você pode acompanhar este produto em mais bairros pela vitrine.';
      case ProductStatus.noNeighborhood:
        return 'Sua localização ainda não possui bairros cadastrados na plataforma.';
      case ProductStatus.notInShowcaseNotAddable:
        return 'Não encontramos este produto na localização atual.';
      case ProductStatus.inShowcaseNoNeighborhoodToAdd:
        return 'Este produto já está sendo acompanhado na sua vitrine.';
      case ProductStatus.inShowcaseNotAddable:
        return 'Sua vitrine está cheia no momento para este produto.';
      case ProductStatus.notReachable:
        return 'Algo deu errado ao carregar as informações.';
      case ProductStatus.error:
        return 'Erro de conexão. Entre novamente para continuar.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationNotifier = context.read<LocationNotifier>();
    final showcaseNotifier = context.read<ShowcaseNotifier>();
    final currentProduct = context.read<ProductNotifier>().currentProduct;

    if (currentProduct == null) {
      return const EmptyWidget();
    }

    final showcaseAddOption = _checkShowcaseAddOptions(
      showcaseNotifier: showcaseNotifier,
      locationNotifier: locationNotifier,
      currentProduct: currentProduct,
    );
    final String message = _message(showcaseAddOption);
    final Widget? actionsWidget = _buildActionsWidget(
      showcaseAddOption: showcaseAddOption,
      showcaseNotifier: showcaseNotifier,
      locationNotifier: locationNotifier,
      currentProduct: currentProduct,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (actionsWidget != null) const SizedBox(height: 20),
          if (actionsWidget != null) actionsWidget,
        ],
      ),
    );
  }
}
