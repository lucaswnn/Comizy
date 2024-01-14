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

  // produto corrente
  String? currentProduct;

  // alternador loja/produto para banco de dados interno
  String shopOrProduct = 'Produto';

  TestData testData = TestData();

  // método para alternar loja/produto para banco de dados interno
  void toggleShopProduct() {
    shopOrProduct == 'Produto'
        ? shopOrProduct = 'Loja'
        : shopOrProduct = 'Produto';
  }

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

  // método para alterar a loja corrente
  void setCurrentProduct(String product) {
    currentProduct = product;
    print(currentProduct);
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
