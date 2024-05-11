import 'package:comizy/src/tad/market.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';

enum SettedState { currentShopSetted, currentProductSetted, nothingSetted }

enum SearchFilterLabel { shopQuery, productQuery }

class MyAppState extends ChangeNotifier {
  // localização atual GPS
  LocationData? currentLocation;

  MapController mapController = MapController();

  // página selecionada da home
  int selectedHomeIndex = 1;

  PageController pageViewController =
      PageController(initialPage: 1, keepPage: true);

  // booleano para exibição da appbar
  bool showAppBar = true;

  // loja corrente
  Shop? currentShop;

  // lojas, produtos e sua associação
  Market market = Market();

  // produto corrente
  Product? currentProduct;

  // carrinho de compras
  Map<Product, int> productsCart = {};

  // relação de lojas e produtos

  // estado de elemento carregado
  SettedState settedState = SettedState.nothingSetted;

  // estado de pesquisa
  Map<SearchFilterLabel, bool> queryState = {
    SearchFilterLabel.productQuery: true,
    SearchFilterLabel.shopQuery: false,
  };

  // DB carregado ou não
  bool isMarketLoaded = false;

  // serviço e permissão GPS autorizados
  bool? isGPSUsable;

  // localização carregada ou não
  bool isLocationLoaded = false;

  String? appBarText = 'Comizy';

  void addProductOnCart(Product product) {
    if (!(productsCart.containsKey(product))) {
      productsCart[product] = 1;
      notifyListeners();
    }
  }

  void increaseProductOnCart(Product product) {
    if (productsCart.containsKey(product)) {
      productsCart[product] = productsCart[product]! + 1;
      notifyListeners();
    }
  }

  void decreaseProductOnCart(Product product) {
    if (productsCart.containsKey(product)) {
      if (productsCart[product]! > 1) {
        productsCart[product] = productsCart[product]! - 1;
        notifyListeners();
      } else if (productsCart[product]! == 1) {
        productsCart.remove(product);
        notifyListeners();
      }
    }
  }

  void clearCart() {
    productsCart.clear();
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

  Future<void> loadMarket() async {
    if (!isMarketLoaded) {
      isMarketLoaded = true;
      await market.getFullMarketInRadius(5000);
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
    appBarText = shop.name;
    notifyListeners();
  }

  // método para alterar a loja corrente
  void setCurrentProduct(Product product) {
    settedState = SettedState.currentProductSetted;
    currentProduct = product;
    currentShop = null;
    appBarText = product.name;
    notifyListeners();
  }

  // método para capturar a localização atual GPS
  void setCurrentLocation(LocationData? loc) {
    if (loc != null) {
      currentLocation = loc;
      isLocationLoaded = true;
      notifyListeners();
    }
  }

  // método para limpar o estado corrente de loja / produto
  void resetItemState() {
    settedState = SettedState.nothingSetted;
    currentProduct = null;
    currentShop = null;
    appBarText = 'Comizy';
    notifyListeners();
  }
}
