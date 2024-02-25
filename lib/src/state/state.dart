import 'dart:js_interop';

import 'package:comizy/src/db/db_access.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

enum SettedState { currentShopSetted, currentProductSetted, nothingSetted }

enum SearchFilterLabel { shopQuery, productQuery }

class MyAppState extends ChangeNotifier {
  // localização atual GPS
  LocationData? currentLocation;

  // página selecionada da home
  int selectedHomeIndex = 1;

  // booleano para exibição da appbar
  bool showAppBar = true;

  // loja corrente
  Shop? currentShop;

  // produtos com a loja corrente
  List<Product>? currentShopProducts;

  // produtos carregados do banco
  List<Product> dataBaseProducts = [];

  // produto corrente
  Product? currentProduct;

  // lojas com o produto corrente
  List<Shop>? currentProductShops;

  // lojas carregadas do banco
  List<Shop> dataBaseShops = [];

  // estado de elemento carregado
  SettedState settedState = SettedState.nothingSetted;

  // estado de pesquisa
  Map<SearchFilterLabel, bool> queryState = {
    SearchFilterLabel.productQuery: true,
    SearchFilterLabel.shopQuery: false,
  };

  // DB carregado ou não
  bool isDBLoaded = false;

  int click = 0;

  String? appBarText;

  void addClick() {
    click++;
    notifyListeners();
  }

  void resetClick() {
    click = 0;
    notifyListeners();
  }

  void resetSearchFilterState() {
    queryState[SearchFilterLabel.productQuery] = true;
    queryState[SearchFilterLabel.shopQuery] = false;
  }

  void setSearchFilterState(SearchFilterLabel label, bool value) {
    queryState[label] = value;
    notifyListeners();
  }

  toggleSearchFilterState() {
    queryState[SearchFilterLabel.productQuery] =
        !queryState[SearchFilterLabel.productQuery]!;

    queryState[SearchFilterLabel.shopQuery] =
        !queryState[SearchFilterLabel.shopQuery]!;

    notifyListeners();
  }

  Future<void> loadDB() async {
    if (!isDBLoaded) {
      dataBaseProducts = Product.productList(await DbAccess.getProductList());
      dataBaseShops = Shop.shopList(await DbAccess.getShopList());
      isDBLoaded = true;
      notifyListeners();
    }
  }

  Future<void> setCurrentProductShops() async {
    if (currentProduct != null) {
      currentProduct!.shops =
          Shop.shopList(await DbAccess.getProductShopsList(currentProduct!));

      double minimumPrice = double.infinity;
      for (final shop in currentProduct!.shops) {
        if (shop.products.first.value.isNull) {
          continue;
        }
        if ((shop.products.first.value!) < minimumPrice) {
          minimumPrice = (shop.products.first.value!);
        }
      }
      currentProduct!.value = minimumPrice;
      notifyListeners();
    }
  }

  Future<void> setCurrentShopProducts() async {
    if (currentShop != null) {
      currentShop!.products =
          Product.productList(await DbAccess.getShopProductsList(currentShop!));
      notifyListeners();
    }
  }

  // método para alterar a página selecionada da home
  void setHomeIndex(int index) {
    index == 0 || index == 1 ? showAppBar = true : showAppBar = false;
    selectedHomeIndex = index;
    notifyListeners();
  }

  // método para alterar a loja corrente
  void setCurrentShop(Shop shop) {
    settedState = SettedState.currentShopSetted;
    currentShop = shop;
    currentProduct = null;
    setCurrentShopProducts();
    appBarText = shop.name;
    notifyListeners();
  }

  // método para alterar a loja corrente
  void setCurrentProduct(Product product) {
    settedState = SettedState.currentProductSetted;
    currentProduct = product;
    currentShop = null;
    setCurrentProductShops();
    appBarText = product.name;
    notifyListeners();
  }

  // método para capturar a localização atual GPS
  void setCurrentLocation(LocationData loc) {
    currentLocation = loc;
  }
}
