import 'dart:developer';

import 'package:comizy/src/db/db_access.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/selling.dart';
import 'package:comizy/src/tad/shop.dart';
import 'package:comizy/src/util/geo_util.dart';

import 'package:latlong2/latlong.dart';

class Market {
  final Map<int, Shop> shops = {};
  final Map<int, Product> products = {};

  Future<void> _addProductsInRadius(LatLng latLng, double radius) async {
    final productsListFromServer =
        await DbAccess.getProductListInRadius(latLng, radius);
    try {
      for (var item in productsListFromServer) {
        final id = item['ID_PRODUTO'];
        final name = item['NOME_PRODUTO'];
        final type = item['CATEGORIA_PRODUTO'];
        final subtype = item['subcategoria_produto'];

        final product = Product(
          id: id,
          name: name,
          type: type,
          subtype: subtype,
        );
        products[id] = product;
      }
    } catch (error) {
      const debugOrigin = 'market:Market._addProductsInRadius';
      log('comizy: exception on $debugOrigin: $error');
    }
  }

  Future<void> _addShopsInRadius(LatLng latLng, double radius) async {
    final shopsListFromServer =
        await DbAccess.getShopListInRadius(latLng, radius);
    try {
      for (var item in shopsListFromServer) {
        final id = item['ID_LOJA'];
        final name = item['NOME_LOJA'];
        final address = item['ENDERECO_LOJA'];
        final location = LatLng(
          item['LATITUDE_LOJA'].toDouble(),
          item['LONGITUDE_LOJA'].toDouble(),
        );
        final type = item['CATEGORIA_LOJA'];

        final shop = Shop(
          id: id,
          name: name,
          address: address,
          location: location,
          type: type,
        );

        shops[id] = shop;
      }
    } catch (error) {
      const debugOrigin = 'market:Market._addShopsInRadius';
      log('comizy: exception on $debugOrigin: $error');
    }
  }

  Future<void> _associateItems(LatLng latLng, double radius) async {
    try {
      final sellingListFromServer =
          await DbAccess.getSellingListInRadius(latLng, radius);

      for (var item in sellingListFromServer) {
        final shopId = item['ID_LOJA'];
        final productId = item['ID_PRODUTO'];
        final value = item['VALOR_VENDA'];
        final lastUpdate = item['ULTIMA_ATUALIZACAO_VENDA'];

        if (shops.containsKey(shopId) && products.containsKey(productId)) {
          final selling = Selling(
            shop: shops[shopId]!,
            product: products[productId]!,
            value: value,
            lastUpdate: lastUpdate,
          );

          shops[shopId]!.associatedProducts[productId] = selling;
          products[productId]!.associatedShops[shopId] = selling;
        }
      }
    } catch (error) {
      const debugOrigin = 'market:Market._associateItems';
      log('comizy: exception on $debugOrigin: $error');
    }
  }

  Future<void> getFullMarketInRadius(double radius) async {
    final location = await getCurrentLocation();
    final latLng = LatLng(location!.latitude!, location.longitude!);
    await _addProductsInRadius(latLng, radius);
    await _addShopsInRadius(latLng, radius);
    await _associateItems(latLng, radius);
  }

  Selling? getMinSellingValue(int productId) {
    if (products.containsKey(productId)) {
      double minValue = double.infinity;
      int minValueId = -1;
      final productOcurrences = products[productId]!.associatedShops;

      for (var id in productOcurrences.keys) {
        if (productOcurrences[id]!.value < minValue) {
          minValue = productOcurrences[id]!.value;
          minValueId = id;
        }
      }

      if (minValueId != -1) {
        return productOcurrences[minValueId];
      }
    }
    return null;
  }

  Selling? getMaxSellingValue(int productId) {
    if (products.containsKey(productId)) {
      double maxValue = double.negativeInfinity;
      int maxValueId = -1;
      final productOcurrences = products[productId]!.associatedShops;

      for (var id in productOcurrences.keys) {
        if (productOcurrences[id]!.value > maxValue) {
          maxValue = productOcurrences[id]!.value;
          maxValueId = id;
        }
      }

      if (maxValueId != -1) {
        return productOcurrences[maxValueId];
      }
    }
    return null;
  }
}
