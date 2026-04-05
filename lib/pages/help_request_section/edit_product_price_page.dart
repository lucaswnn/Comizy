import 'package:comizy/services/change_notifiers/async_action_notifier.dart';
import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/shop_notifier.dart';
import 'package:comizy/services/command/submit_price_command.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/utils/extensions.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/widgets/async_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductPricePage extends StatefulWidget {
  const EditProductPricePage({super.key});

  @override
  State<EditProductPricePage> createState() => _EditProductPricePageState();
}

class _EditProductPricePageState extends State<EditProductPricePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
  }

  Widget _buildForm({
    required Product product,
    required Shop shop,
    required AsyncActionNotifier<SubmitPriceResult> asyncActionNotifier,
    required HelpRequestNotifier helpRequestNotifier,
    required MarketNotifier marketNotifier,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: 'Preço do ${product.name} no ${shop.name}',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um preço';
              }
              final price = double.tryParse(value.replaceFirst(',', '.'));
              if (price == null || price < 0) {
                return 'Por favor, insira um preço válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          AsyncElevatedButton(
            notifier: asyncActionNotifier,
            command: SubmitPriceCommand(
              helpRequestNotifier: helpRequestNotifier,
              marketNotifier: marketNotifier,
              validator: () => _formKey.currentState?.validate() ?? false,
              priceProvider: () => double.parse(_priceController.text),
              product: product,
              shop: shop,
            ),
            child: const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherHelpRequests({
    required Shop shop,
    required HelpRequestNotifier helpRequestNotifier,
    required MarketNotifier marketNotifier,
  }) {
    final offers =
        marketNotifier.market.needingUpdateOffersOnShop(shop).entries.toList();
    if (offers.isEmpty) {
      return const Center(
        child: Text('Essa loja não possui mais produtos para cadastrar'),
      );
    }
    return Column(
      children: [
        const Flexible(
          child: Text('Outras pessoas também gostariam de saber dessa loja'),
        ),
        const SizedBox(height: 10),
        Flexible(
          flex: 5,
          child: ListView.builder(
            itemCount: offers.length,
            itemBuilder: (_, i) {
              final offer = offers[i].key;
              final offerInfo = offers[i].value;
              return ListTile(
                title: Text('$offer'),
                subtitle: Text(
                    'Último preço em: ${offerInfo.lastUpdated.toShortDateString}'),
                onTap: () {
                  helpRequestNotifier.currentProductRequest = offer.product;
                  NavigationHelper.pushReplacementNamed(
                      AppRoutes.editProductPricePage);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void showResponseDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text('Voltar'),
              onPressed: () {
                NavigationHelper.pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.read<ShopNotifier>().currentShop;
    final helpRequestNotifier = context.read<HelpRequestNotifier>();
    final product = helpRequestNotifier.currentProductRequest;
    if (product == null || shop == null) return const InvalidRoute();

final marketNotifier = context.read<MarketNotifier>();

    return ChangeNotifierProvider(
      create: (_) => AsyncActionNotifier<SubmitPriceResult>(),
      child: Consumer<AsyncActionNotifier<SubmitPriceResult>>(
        builder: (context, asyncActionNotifier, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (asyncActionNotifier.result) {
              case SubmitPriceResult.success:
                showResponseDialog(
                  title: 'Sucesso ao cadastrar',
                  content: 'Produto cadastrado com sucesso.',
                );
                break;
              case SubmitPriceResult.notValidated:
                break;
              case SubmitPriceResult.failure:
                showResponseDialog(
                  title: 'Falha ao cadastrar',
                  content: 'Houve uma falha do servidor. '
                      'Tente novamente mais tarde.',
                );
                asyncActionNotifier.reset();
                break;
              case null:
                break;
            }
          });

          Widget content;
          switch (asyncActionNotifier.result) {
            case SubmitPriceResult.success:
              content = _buildOtherHelpRequests(
                shop: shop,
                helpRequestNotifier: helpRequestNotifier,
                marketNotifier: marketNotifier,
              );
              break;
            case SubmitPriceResult.notValidated:
            case SubmitPriceResult.failure:
            case null:
              content = _buildForm(
                product: product,
                shop: shop,
                asyncActionNotifier: asyncActionNotifier,
                helpRequestNotifier: helpRequestNotifier,
                marketNotifier: marketNotifier,
              );
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Editar preço do produto'),
              leading: IconButton(
                onPressed: () =>
                    NavigationHelper.pushNamedAndClearStack(AppRoutes.mainPage),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: content,
          );
        },
      ),
    );
  }
}
