import 'package:comizy/tad/market.dart';
import 'package:comizy/tad/product.dart';
import 'package:comizy/tad/shop.dart';
import 'package:flutter/material.dart';

class MarketState extends ChangeNotifier {
  // lojas, produtos e sua associação
  Market market = Market();

  // DB carregado ou não
  bool? isMarketLoaded;

  // loja corrente
  Shop? currentShop;

  // produto corrente
  Product? currentProduct;

  // carregar o mercado
  Future<void> loadMarket() async {
    if (isMarketLoaded == null) {
      try {
        await market.getFullMarketInRadius(3000);
        isMarketLoaded = true;
      } on EmptyMarketException catch (_) {
        isMarketLoaded = false;
      } finally {
        notifyListeners();
      }
    }
  }

  // método para alterar a loja corrente
  void setCurrentShop(Shop shop) {
    currentShop = shop;
    currentProduct = null;
    notifyListeners();
  }

  // método para alterar a loja corrente
  void setCurrentProduct(Product product) {
    currentProduct = product;
    currentShop = null;
    notifyListeners();
  }

  // método para limpar o estado corrente de loja / produto
  void resetItemState() {
    currentProduct = null;
    currentShop = null;
    notifyListeners();
  }
}
