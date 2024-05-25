import 'dart:developer';

import 'package:comizy/src/state/state.dart';
import 'package:comizy/src/tad/shop.dart';
import 'package:comizy/src/util/geo_util.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatelessWidget {
  final Shop shop;
  const ShopScreen({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final state = context.read<MyAppState>();

    final LatLng shopLocation = shop.location;

    return _buildMainShopScaffold(context, state, shopLocation);
  }

  Scaffold _buildMainShopScaffold(
      BuildContext context, MyAppState state, LatLng shopLocation) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shop.name),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName('/init')),
              icon: const Icon(Icons.arrow_back))
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 300,
            minHeight: 100,
            maxHeight: 300,
          ),
          child: Column(
            children: [
              _mainCard(
                context,
                state,
                shopLocation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _mainCard(
    BuildContext context,
    MyAppState state,
    LatLng shopLocation,
  ) {
    List<Text> topInfo = [];
    if (state.currentLocation != null) {
      LatLng currentLocation = LatLng(
          state.currentLocation!.latitude!, state.currentLocation!.longitude!);
      topInfo.add(
        Text(
          '${calculateDistance(
            currentLocation,
            shop.location,
          ).toStringAsFixed(2)} km',
          style: const TextStyle(fontSize: 20),
        ),
      );
      topInfo.add(const Text(
        'Distância atual',
        style: TextStyle(fontSize: 15),
      ));
    } else {
      const debugOrigin = 'shop_screen:ShopScreen._mainCard';
      log('comizy: unpredicted state on $debugOrigin');
    }

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 8.0,
      shadowColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                ...topInfo,
              ],
            ),
          ),
          const SizedBox(height: 20),
          state.currentShop != null
              ? _mainBottomButtons(context, state, shopLocation)
              : _commonBottomButtons(context, state),
        ],
      ),
    );
  }

  Container _mainBottomButtons(
      BuildContext context, MyAppState state, LatLng shopLocation) {
    return Container(
      height: 42,
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              color: Colors.white,
              onPressed: () {
                state.setHomeIndex(0);
                state.pageViewController.jumpToPage(0);
                Navigator.popUntil(context, ModalRoute.withName('/init'));
              },
              icon: const Icon(Icons.list)),
          IconButton(
              color: Colors.white,
              onPressed: () {
                state.setHomeIndex(1);
                state.mapController.move(shop.location, 13.0);
                state.pageViewController.jumpToPage(1);
                Navigator.popUntil(context, ModalRoute.withName('/init'));
              },
              icon: const Icon(Icons.location_on)),
        ],
      ),
    );
  }

  Container _commonBottomButtons(BuildContext context, MyAppState state) {
    return Container(
      height: 42,
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              color: Colors.white,
              onPressed: () {
                state.setCurrentShop(shop);
                state.setHomeIndex(0);
                state.pageViewController.jumpToPage(0);
                Navigator.popUntil(context, ModalRoute.withName('/init'));
              },
              icon: const Icon(Icons.list)),
          IconButton(
              color: Colors.white,
              onPressed: () {
                state.setHomeIndex(1);
                state.mapController.move(shop.location, 13.0);
                state.pageViewController.jumpToPage(1);
                Navigator.popUntil(context, ModalRoute.withName('/init'));
              },
              icon: const Icon(Icons.location_on)),
        ],
      ),
    );
  }

  static void showShopScreen(BuildContext context, Shop shop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopScreen(
          shop: shop,
        ),
      ),
    );
  }
}
