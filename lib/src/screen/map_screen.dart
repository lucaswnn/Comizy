import 'package:comizy/src/screen/shop_screen.dart';
import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData? _currentLocation;
  final List<Marker> _markers = [];
  final List<Marker> _currentLocMarker = [];
  final List<CircleMarker> _currentLocCircleMarker = [];
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    final state = context.read<MyAppState>();
    _mapController = state.mapController;
    getCurrentLocation(state);
  }

  @override
  void dispose()
  {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> getCurrentLocation(MyAppState state) async {
    try {
      _currentLocation = await Location().getLocation();
      state.setCurrentLocation(_currentLocation!);

      _currentLocCircleMarker.add(createLocCircleMarker());
      _currentLocMarker.add(createLocMarker());

      _mapController.move(
        LatLng(
          _currentLocation!.latitude!,
          _currentLocation!.longitude!,
        ),
        13.0,
      );
    } catch (e) {
      print(
          'comizy: error getting current location - on map_screen._mapScreenState.getCurrentLocation');
      print(e);
    }
  }

  CircleMarker createLocCircleMarker() {
    return CircleMarker(
      point: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      radius:
          _currentLocation!.accuracy! == 0 ? 500 : _currentLocation!.accuracy!,
      useRadiusInMeter: true,
      borderColor: Colors.lightBlue,
      borderStrokeWidth: 3,
      color: const Color.fromARGB(24, 0, 204, 255),
    );
  }

  Marker createLocMarker() {
    return Marker(
      width: 40.0,
      height: 40.0,
      point: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      builder: (context) => const Icon(
        Icons.circle,
        size: 15,
        shadows: [
          Shadow(
            color: Colors.blueAccent,
            blurRadius: 6,
          )
        ],
        color: Colors.blue,
      ),
    );
  }

  ShopMarker createShopMarker(Shop shop) {
    return ShopMarker(
        width: 40,
        height: 40,
        anchorPos: AnchorPos.align(AnchorAlign.center),
        shopData: shop,
        point: shop.location,
        builder: (context) {
          Color iconColor = const Color.fromARGB(255, 184, 184, 184);
          if (Product.minimumValueShop != null) {
            if (shop.id == Product.minimumValueShop!.id) {
              iconColor = Colors.blue;
            }
          }

          return IconButton(
            icon: Icon(
              Icons.location_on_sharp,
              shadows: const [
                Shadow(
                  color: Colors.black,
                  blurRadius: 3,
                ),
              ],
              color: iconColor,
            ),
            iconSize: 30,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            onPressed: () => ShopScreen.showShopScreen(context, shop),
          );
        });
  }

  void loadShops(List<Shop> shops) {
    _markers.clear();
    for (var shop in shops) {
      _markers.add(createShopMarker(shop));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MyAppState>(context, listen: true);
    if (state.settedState == SettedState.currentShopSetted) {
      loadShops([state.currentShop!]);
    } else if (state.settedState == SettedState.currentProductSetted) {
      loadShops(state.currentProduct!.shops);
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        maxZoom: 17.7,
        keepAlive: true,
        center: const LatLng(0, 0),
        zoom: 13,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          showFlutterMapAttribution: false,
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap',
              prependCopyright: true,
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.comizy.comizy',
        ),
        CircleLayer(
          circles: _currentLocCircleMarker,
        ),
        MarkerLayer(
          markers: _markers,
        ),
        MarkerLayer(
          markers: _currentLocMarker,
        )
      ],
    );
  }
}

class ShopMarker extends Marker {
  Shop shopData;
  ShopMarker(
      {required super.point,
      required super.builder,
      required this.shopData,
      super.anchorPos,
      super.height,
      super.key,
      super.rotate,
      super.rotateAlignment,
      super.rotateOrigin,
      super.width});
}
