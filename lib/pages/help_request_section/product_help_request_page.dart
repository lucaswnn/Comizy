import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/shop_notifier.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ProductHelpRequestPage extends StatefulWidget {
  const ProductHelpRequestPage({super.key});

  @override
  State<ProductHelpRequestPage> createState() => _ProductHelpRequestPageState();
}

class _ProductHelpRequestPageState extends State<ProductHelpRequestPage> {
  final MapController _mapController = MapController();
  Shop? _selectedShop;

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  void Function() _onShopTap(Shop shop) {
    return () {
      if (_selectedShop != null && _selectedShop == shop) {
        context.read<ShopNotifier>().currentShop = shop;
        NavigationHelper.pushNamed(AppRoutes.editProductPricePage);
        return;
      }

      setState(() => _selectedShop = shop);
    };
  }

  @override
  Widget build(BuildContext context) {
    final locationNotifier = context.read<LocationNotifier>();
    final settedLocation = locationNotifier.settedLocation;
    final currentLocation = locationNotifier.currentLocation;
    LatLng initialCenter = LocationNotifier.defaultLocation;
    double initialZoom = 6;
    if (currentLocation != null) {
      initialCenter = currentLocation;
      initialZoom = 14;
    } else if (settedLocation != null) {
      initialCenter = settedLocation;
      initialZoom = 14;
    }

    final shops = context.read<MarketNotifier>().market.shops
      ..sort(Shop.compareWithDistance(initialCenter));

    final markers = [
      if (currentLocation != null)
        Marker(
          point: currentLocation,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 40,
          ),
        ),
      ...shops.map(
        (shop) {
          if (_selectedShop != null && _selectedShop == shop) {
            return Marker(
              point: shop.location,
              child: IconButton(
                onPressed: _onShopTap(shop),
                icon: const Icon(
                  Icons.location_pin,
                  color: Colors.blue,
                  size: 50,
                ),
              ),
            );
          }

          return Marker(
            point: shop.location,
            child: IconButton(
              onPressed: _onShopTap(shop),
              icon: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          );
        },
      ),
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
              mapController: _mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: initialZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: shops.length,
              itemBuilder: (_, i) {
                final shop = shops[i];
                bool isCurrentSelected =
                    _selectedShop != null && _selectedShop == shop;
                return ListTile(
                  tileColor: isCurrentSelected ? Colors.blue.shade100 : null,
                  title: Text(shop.name),
                  onTap: _onShopTap(shop),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
