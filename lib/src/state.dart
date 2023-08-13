import 'package:flutter/material.dart';

import 'package:comizy/src/fonte_testes.dart';
import 'package:location/location.dart';

class MyAppState extends ChangeNotifier {
  LocationData? currentLocation;
  TestData testData = TestData();

  Future<void> loadCurrentLocation() async {
    try {
      final loc = Location();
      currentLocation = await loc.getLocation();
      print(currentLocation!.latitude!);
    } catch (e) {
      print('erro_comizy_state');
    }
  }
}
