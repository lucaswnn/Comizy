import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/shop_notifier.dart';
import 'package:comizy/services/shared_preferenes/app_preferences.dart';
import 'package:comizy/tads/market.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/utils/location_alert_dialog.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class HelpRequestPage extends StatefulWidget {
  const HelpRequestPage({super.key});

  @override
  State<HelpRequestPage> createState() => _HelpRequestPageState();
}

class _HelpRequestPageState extends State<HelpRequestPage> {
  Shop? _selectedShop;

  void Function() _onShopTap(Shop shop) {
    return () {
      setState(() => _selectedShop = shop);
    };
  }

  void _openPricePage({required Shop shop, required Product product}) {
    context.read<ShopNotifier>().currentShop = shop;
    context.read<HelpRequestNotifier>().currentProductRequest = product;
    NavigationHelper.pushNamed(AppRoutes.editProductPricePage);
  }

  @override
  Widget build(BuildContext context) {
    final locationNotifier = context.read<LocationNotifier>();
    if (locationNotifier.settedLocation == null) {
      return Column(
        children: [
          const Text('Associe uma localização para cadastrar os preços'),
          IconButton(
            onPressed: () async {
              final shouldShowDialog =
                  await AppPreferences.shouldShowLocationMessage();
              if (!context.mounted) return;

              if (shouldShowDialog) {
                showDialog(
                    context: context,
                    builder: (_) => const LocationAlertDialog());
              } else {
                locationNotifier.askForGPS();
                NavigationHelper.pushNamed(AppRoutes.setLocationPage);
              }
            },
            icon: const Icon(Icons.location_pin),
          ),
        ],
      );
    }

    final market = context.watch<MarketNotifier>().market;
    final helpRequestNotifier = context.read<HelpRequestNotifier>();

    final settedLocation = locationNotifier.settedLocation;
    final currentLocation = locationNotifier.currentLocation;

    LatLng initialCenter = LocationNotifier.defaultLocation;
    double initialZoom = 6;
    if (settedLocation != null) {
      initialCenter = settedLocation;
      initialZoom = 14;
    }

    final helpRequests = helpRequestNotifier.helpRequests;
    print(helpRequests.helpRequestItems);
    final offers = market.filterOffersByHelpRequests(helpRequests);
    print(offers);
    final shops = Market.shopsFromOffers(offers);
    print(shops);

    final selectedShopOffers = _selectedShop == null
        ? <MapEntry<Offer, OfferInfo>>[]
        : (offers.entries
            .where((entry) => entry.key.shop == _selectedShop)
            .toList()
          ..sort((a, b) => a.key.product.name.compareTo(b.key.product.name)));

    const commonMarkerSize = 40.0;
    const selectedMarkerSize = 45.0;

    final markers = [
      if (currentLocation != null)
        Marker(
          point: currentLocation,
          width: commonMarkerSize,
          height: commonMarkerSize,
          child: const Icon(
            Icons.my_location,
            color: Colors.blue,
            size: commonMarkerSize,
          ),
        ),
      ...shops.map((shop) {
        final isSelected = _selectedShop == shop;
        return Marker(
          width: isSelected ? selectedMarkerSize : commonMarkerSize,
          height: isSelected ? selectedMarkerSize : commonMarkerSize,
          point: shop.location,
          child: IconButton(
            onPressed: _onShopTap(shop),
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.location_pin,
              color: isSelected ? Colors.blue : Colors.red,
              size: isSelected ? selectedMarkerSize : commonMarkerSize,
            ),
          ),
        );
      }),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lojas que precisam de cadastro'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: initialZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.comizy.app',
                  tileProvider: NetworkTileProvider(),
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _selectedShop == null
                ? const Center(
                    child: Text('Toque em uma loja no mapa para ver os itens'),
                  )
                : selectedShopOffers.isEmpty
                    ? const Center(
                        child: Text(
                          'Essa loja não possui itens pendentes para cadastro',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: selectedShopOffers.length,
                        itemBuilder: (_, i) {
                          final offer = selectedShopOffers[i].key;
                          final offerInfo = selectedShopOffers[i].value;
                          return ListTile(
                            leading: const Icon(Icons.volunteer_activism),
                            title: Text('${offer.product}'),
                            subtitle: Text(
                              'Último preço em: ${offerInfo.lastUpdated}',
                            ),
                            onTap: () {
                              _openPricePage(
                                shop: _selectedShop!,
                                product: offer.product,
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
