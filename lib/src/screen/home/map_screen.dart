import 'package:comizy/src/screen/etc/shop_screen.dart';
import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/selling.dart';
import 'package:comizy/src/tad/shop.dart';
import 'package:comizy/src/util/geo_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

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
    _setCurrentLocationOnMap(state);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _setCurrentLocationOnMap(MyAppState state) async {
    _currentLocation = await getCurrentLocation();

    if (_currentLocation == null) {
      return;
    }
    state.setCurrentLocation(_currentLocation!);

    _currentLocCircleMarker.add(_createLocCircleMarker());
    _currentLocMarker.add(_createLocMarker());

    _mapController.move(
      LatLng(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
      ),
      13.0,
    );
  }

  CircleMarker _createLocCircleMarker() {
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

  Marker _createLocMarker() {
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

  IconButton _buildLocationIconButton({
    required Shop shop,
    required double size,
    required Color iconColor,
    Color shadowColor = Colors.black,
  }) {
    return IconButton(
      icon: Icon(
        Icons.location_on_sharp,
        shadows: [
          Shadow(
            color: shadowColor,
            blurRadius: 3,
          ),
        ],
        color: iconColor,
      ),
      iconSize: size,
      padding: EdgeInsets.zero,
      onPressed: () => ShopScreen.showShopScreen(context, shop),
    );
  }

  ShopMarker _buildShopMarker(
      {required Shop shop,
      required double size,
      required Color color,
      Color shadowColor = Colors.black}) {
    return ShopMarker(
      width: size,
      height: size,
      //anchorPos: AnchorPos.align(AnchorAlign.center),
      shopData: shop,
      point: shop.location,
      anchorPos: AnchorPos.align(AnchorAlign.top),
      builder: (context) {
        return _buildLocationIconButton(
          shop: shop,
          size: size,
          iconColor: color,
          shadowColor: shadowColor,
        );
      },
    );
  }

  ShopMarker _createShopMarker(Shop shop) {
    final state = context.read<MyAppState>();

    if (state.settedState == SettedState.currentShopSetted &&
        shop.id == state.currentShop!.id) {
      return _buildShopMarker(
        shop: state.currentShop!,
        size: 40,
        color: const Color.fromARGB(255, 252, 62, 49),
        shadowColor: Colors.white,
      );
    } else if (state.settedState == SettedState.currentProductSetted) {
      Selling? minimumSelling;
      minimumSelling =
          state.market.getMinSellingValue(state.currentProduct!.id);
      if (minimumSelling != null && shop.id == minimumSelling.shop.id) {
        return _buildShopMarker(
          shop: minimumSelling.shop,
          size: 40,
          color: const Color.fromARGB(255, 31, 46, 255),
          shadowColor: Colors.white,
        );
      }
    }

    return _buildShopMarker(
      shop: shop,
      size: 30,
      color: const Color.fromARGB(255, 158, 158, 158),
    );
  }

  void _loadShops(List<Shop> shops) {
    _clearShops();
    for (var shop in shops) {
      _markers.add(_createShopMarker(shop));
    }
  }

  void _clearShops() => _markers.clear();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyAppState>();
    if (state.settedState == SettedState.currentShopSetted) {
      _loadShops([state.currentShop!]);
    } else if (state.settedState == SettedState.currentProductSetted) {
      final returnList = state.currentProduct!.associatedShops.entries
          .map((entry) => entry.value.shop)
          .toList();
      _loadShops(returnList);
    } else {
      final returnList =
          state.market.shops.entries.map((entry) => entry.value).toList();
      _loadShops(returnList);
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
          alignment: AttributionAlignment.bottomLeft,
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
