import 'package:comizy/services/change_notifiers/offer_register_change_notifier.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/utils/input_formatters.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfferRegisterScreen extends StatefulWidget {
  const OfferRegisterScreen({super.key});

  @override
  State<OfferRegisterScreen> createState() => _OfferRegisterScreenState();
}

class _OfferRegisterScreenState extends State<OfferRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  late final Offer _offer;

  @override
  void initState() {
    _offer = context.read<OfferRegisterChangeNotifier>().currentOffer!;
    super.initState();
  }

  void _saveOffer() {
    if (_formKey.currentState!.validate()) {
      final price = double.parse(_priceController.text.replaceAll(',', '.'));
      final offer = Offer(
        product: _offer.product,
        shop: _offer.shop,
        price: price,
      );

      context.read<OfferRegisterChangeNotifier>().registerCurrentOffer();
      NavigationHelper.pop(offer);
    }
  }

  String? _priceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Informe o preço";
    }
    final formattedValue = value.replaceAll(',', '.');
    if (double.tryParse(formattedValue) == null) {
      return "Digite um número válido";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar preço - ${_offer.product.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Loja: ${_offer.shop.name}"),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Preço",
                  border: OutlineInputBorder(),
                ),
                validator: _priceValidator,
                inputFormatters: [CurrencyInputFormatter()],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveOffer,
                child: const Text("Salvar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
