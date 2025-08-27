import 'package:comizy/services/change_notifiers/offer_register_change_notifier.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfferRegisterListPageview extends StatefulWidget {
  const OfferRegisterListPageview({super.key});

  @override
  State<OfferRegisterListPageview> createState() =>
      _OfferRegisterListPageviewState();
}

class _OfferRegisterListPageviewState extends State<OfferRegisterListPageview> {
  late List<Offer> _offers;

  @override
  void initState() {
    _offers = context.read<OfferRegisterChangeNotifier>().offerRegisters;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: _offers.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_offers[index].product.name),
          subtitle: Text("Loja: ${_offers[index].shop.name}"),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            context.read<OfferRegisterChangeNotifier>().currentOffer =
                _offers[index];
            final changedOffer = await NavigationHelper.pushNamed<Offer>(
                AppRoutes.offerRegister);
            if (changedOffer != null) {
              setState(() => _offers =
                  context.read<OfferRegisterChangeNotifier>().offerRegisters);
            }
          },
        ),
      );
}
