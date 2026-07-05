import 'package:comizy/services/change_notifiers/async_action_notifier.dart';
import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/shop_notifier.dart';
import 'package:comizy/services/command/submit_price_command.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/utils/extensions.dart';
import 'package:comizy/utils/input_formatters.dart';
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
  SubmitPriceResult? _lastShownDialogResult;

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
            inputFormatters: [CurrencyInputFormatter()],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe um preço';
              }
              final price = double.tryParse(value.replaceFirst(',', '.'));
              if (price == null || price < 0) {
                return 'Informe um preço válido';
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
              priceProvider: () =>
                  double.parse(_priceController.text.replaceFirst(',', '.')),
              product: product,
              shop: shop,
            ),
            child: const Text('Enviar preço'),
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
        marketNotifier.needingUpdateOffersOnShop(shop).entries.toList();
    if (offers.isEmpty) {
      return const Center(
        child: Text('Esta loja não possui mais produtos pendentes'),
      );
    }
    return Column(
      children: [
        const Flexible(
          child:
              Text('Outras pessoas também querem atualizar preços desta loja'),
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
              child: const Text('Fechar'),
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
          final result = asyncActionNotifier.result;
          if (result == null) {
            _lastShownDialogResult = null;
          }

          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (result == null || result == _lastShownDialogResult) {
                return;
              }

              _lastShownDialogResult = result;

              switch (result) {
                case SubmitPriceResult.success:
                  showResponseDialog(
                    title: 'Preço enviado com sucesso',
                    content: 'Obrigado por contribuir com a comunidade.',
                  );
                  break;
                case SubmitPriceResult.hold:
                  showResponseDialog(
                    title: 'Contribuição em análise',
                    content:
                        'Recebemos seu envio e ele será validado em breve.',
                  );
                  break;
                case SubmitPriceResult.error:
                  showResponseDialog(
                    title: 'Não foi possível enviar',
                    content:
                        'Houve uma falha no servidor. Tente novamente mais tarde.',
                  );
                  asyncActionNotifier.reset();
                  break;
                case SubmitPriceResult.invalid:
                  break;
              }
            },
          );

          Widget content;
          switch (result) {
            case SubmitPriceResult.success:
            case SubmitPriceResult.hold:
              content = _buildOtherHelpRequests(
                shop: shop,
                helpRequestNotifier: helpRequestNotifier,
                marketNotifier: marketNotifier,
              );
              break;
            case SubmitPriceResult.invalid:
            case SubmitPriceResult.error:
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
              title: const Text('Cadastrar preço do produto'),
              leading: IconButton(
                onPressed: () =>
                    NavigationHelper.pushNamedAndClearStack(AppRoutes.mainPage),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: content,
              ),
            ),
          );
        },
      ),
    );
  }
}
