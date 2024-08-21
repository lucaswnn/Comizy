import 'dart:developer';
import 'package:latlong2/latlong.dart';

import 'package:comizy/db/db_access.dart';
import 'package:comizy/tad/product.dart';
import 'package:comizy/tad/selling.dart';
import 'package:comizy/tad/shop.dart';
import 'package:comizy/util/geo_util.dart';

// classe que associa lojas com produtos
class Market {
  final Map<int, Shop> shops = {};
  final Map<int, Product> products = {};

  // carrega produtos com base em um local e um raio de busca
  Future<void> _addProductsInRadius(LatLng latLng, double radius) async {
    final productsListFromServer =
        await DbAccess.getProductListInRadius(latLng, radius);
    try {
      for (var item in productsListFromServer) {
        final id = item['ID_PRODUTO'];
        final name = item['NOME_PRODUTO'];
        final type = item['CATEGORIA_PRODUTO'];
        final subtype = item['SUBCATEGORIA_PRODUTO'];

        final product = Product(
          id: id,
          name: name,
          type: type,
          subtype: subtype,
        );
        products[id] = product;
      }
    } catch (error) {
      products.clear();
      const debugOrigin = 'market:Market._addProductsInRadius';
      log('comizy: exception on $debugOrigin: $error');
    }
  }

  // carrega lojas com base em um local e um raio de busca
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
      shops.clear();
      const debugOrigin = 'market:Market._addShopsInRadius';
      log('comizy: exception on $debugOrigin: $error');
    }
  }

  // associa os pares de loja e produto do banco de dados com base em um local e um raio de busca
  Future<void> _associateItems(LatLng latLng, double radius) async {
    try {
      final sellingListFromServer =
          await DbAccess.getSellingListInRadius(latLng, radius);

      for (var item in sellingListFromServer) {
        final shopId = item['ID_LOJA'];
        final productId = item['ID_PRODUTO'];
        final value = item['VALOR_VENDA'];

        // associa loja e produto
        if (shops.containsKey(shopId) && products.containsKey(productId)) {
          final selling = Selling(
            shop: shops[shopId]!,
            product: products[productId]!,
            value: value,
          );

          shops[shopId]!.associatedProducts[productId] = selling;
          products[productId]!.associatedShops[shopId] = selling;
        }
      }
    } catch (error) {
      products.clear();
      shops.clear();
      const debugOrigin = 'market:Market._associateItems';
      log('comizy: exception on $debugOrigin: $error');
    }
  }

  // carrega produtos e lojas com base em um local e um raio de busca
  Future<void> getFullMarketInRadius(double radius) async {
    final location = await getCurrentLocation();
    final latLng = LatLng(location!.latitude!, location.longitude!);
    await _addProductsInRadius(latLng, radius);
    await _addShopsInRadius(latLng, radius);
    await _associateItems(latLng, radius);
    if(shops.isEmpty){throw EmptyMarketException();}
  }
}

class EmptyMarketException implements Exception {
  EmptyMarketException();

  @override
  String toString() =>
      'Mercado inexistente';
}
