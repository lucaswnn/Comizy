import 'package:flutter/material.dart';
import 'package:comizy/src/fonte_testes.dart';
import 'package:location/location.dart';

class MyAppState extends ChangeNotifier {
  // localização atual GPS
  LocationData? currentLocation;

  // página selecionada da home
  int selectedHomeIndex = 1;

  // booleano para exibição da appbar
  bool showAppBar = false;

  // loja corrente
  String? currentShop;

  TestData testData = TestData();

  // método para alterar a página selecionada da home
  void setHomeIndex(int index) {
    index == 0 ? showAppBar = true : showAppBar = false;
    selectedHomeIndex = index;
    notifyListeners();
    print('state $selectedHomeIndex, bool $showAppBar');
  }

  // método para alterar a loja corrente
  void setCurrentShop(String shop) {
    currentShop = shop;
    print(currentShop);
  }

  // método para capturar a localização atual GPS
  Future<void> loadCurrentLocation() async {
    try {
      final loc = Location();
      currentLocation = await loc.getLocation();
      print(currentLocation!.latitude!);
    } catch (e) {
      print('erro ao capturar a localização atual');
    }
  }
}
