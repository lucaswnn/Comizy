import 'dart:convert';
import 'dart:developer';
import 'package:comizy/tad/user.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'package:comizy/tad/product.dart';
import 'package:comizy/tad/shop.dart';

class DbAccess {
  static const baseIpv4 = 'https://comizy.link:3000';

  // corpo de uma requisição get
  static Future<List<Map<String, dynamic>>> _httpGet(
    String url,
    String debugOrigin,
  ) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        return data;
      } else {
        log('comizy: error on $debugOrigin: ${response.statusCode}\n${response.body}');
        return [];
      }
    } catch (error) {
      log('comizy: exception on $debugOrigin: $error');
      return [];
    }
  }

  // lista de produtos do servidor
  static Future<List<Map<String, dynamic>>> getProductList() async {
    String url = '$baseIpv4/lista_produtos';
    return await _httpGet(url, 'db_access:DbAccess.getProductList');
  }

  // lista de produtos do servidor em um raio
  static Future<List<Map<String, dynamic>>> getProductListInRadius(
    LatLng latLng,
    double radius,
  ) async {
    String url =
        '$baseIpv4/lista_produtos_em_raio/${latLng.latitude}/${latLng.longitude}/$radius';
    return await _httpGet(url, 'db_access:DbAccess.getProductListInRadius');
  }

  // lista de lojas do produto atual do contexto
  static Future<List<Map<String, dynamic>>> getProductShopsList(
    Product product,
  ) async {
    String url = '$baseIpv4/lista_lojas_produto/${product.id}';
    return await _httpGet(url, 'db_access:DbAccess.getProductShopsList');
  }

  // lista de lojas do servidor
  static Future<List<Map<String, dynamic>>> getShopList() async {
    String url = '$baseIpv4/lista_lojas';
    return await _httpGet(url, 'db_access:DbAccess.getShopList');
  }

  // lista de lojas do servidor em um raio
  static Future<List<Map<String, dynamic>>> getShopListInRadius(
    LatLng latLng,
    double radius,
  ) async {
    String url =
        '$baseIpv4/lista_lojas_em_raio/${latLng.latitude}/${latLng.longitude}/$radius';
    return await _httpGet(url, 'db_access:DbAccess.getShopListInRadius');
  }

  // lista de lojas do produto atual do contexto
  static Future<List<Map<String, dynamic>>> getShopProductsList(
    Shop shop,
  ) async {
    String url = '$baseIpv4/lista_produtos_loja/${shop.id}';
    return await _httpGet(url, 'db_access:DbAccess.getShopProductsList');
  }

  // lista de vendas em raio
  static Future<List<Map<String, dynamic>>> getSellingListInRadius(
    LatLng latLng,
    double radius,
  ) async {
    String url =
        '$baseIpv4/lista_vendas_em_raio/${latLng.latitude}/${latLng.longitude}/$radius';
    return await _httpGet(url, 'db_access:DbAccess.getSellingListInRadius');
  }

  static Future<List<Map<String, dynamic>>> genericGet(String query) async {
    String url = '$baseIpv4/get_generico/$query';
    return await _httpGet(url, 'db_access:DbAccess.genericGet');
  }

  // corpo de uma requisição post
  static Future<RouteContent?> _httpPost(
    String url,
    Map<String, dynamic> data,
    String debugOrigin,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      log('comizy: $debugOrigin: ${response.statusCode}\n${response.body}');
      return RouteContent(data: {}, response: response);
    } catch (error) {
      log('comizy: exception on $debugOrigin: $error');
    }
    return null;
  }

  static Future<RouteContent?> userRegister(User user) async {
    String url = '$baseIpv4/autenticacao/registro';
    Map<String, dynamic> data = {
      'nome_usuario': user.name,
      'email_usuario': user.email,
      'senha': user.password,
      'telefone_usuario': user.telephone,
    };

    return
        await _httpPost(url, data, 'db_access:DbAccess.userRegister');
  }

  // método para adicionar produto no servidor
  static Future<void> addProduct(Product product) async {
    String url = '$baseIpv4/adicionar_produto';
    Map<String, dynamic> data = {
      'nome': product.name,
      'categoria': product.category.type,
    };
    await _httpPost(url, data, 'db_access:DbAccess.addProduct');
  }

  static Future<void> addShop(Shop shop) async {
    String url = '$baseIpv4/adicionar_loja';
    Map<String, dynamic> data = {
      'nome': shop.name,
      'endereco': shop.address,
      'latitude': shop.location.latitude,
      'longitude': shop.location.longitude,
    };
    await _httpPost(url, data, 'db_access:DbAccess.addShop');
  }

  static Future<void> addGenericSearchHistory(
      LocationData? loc, String item) async {
    String url = '$baseIpv4/adicionar_pesquisa_generica';

    final now = DateTime.now();
    final formattedNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    Map<String, dynamic> data = {
      'id_usuario': 1,
      'item_pesquisa_generica': item,
      'data_hora_pesquisa_generica': formattedNow,
      'latitude_pesquisa_generica': loc == null ? 0 : (loc.latitude ?? 0),
      'longitude_pesquisa_generica': loc == null ? 0 : (loc.longitude ?? 0),
    };

    await _httpPost(url, data, 'db_access:DbAccess.addGenericSearchHistory');
  }

  static Future<void> addGenericRegister(String item, String origin) async {
    String url = '$baseIpv4/adicionar_cadastro_generico';

    Map<String, String> data = {
      'solicitacao': item,
      'origem_solicitacao_generica': origin
    };
    await _httpPost(url, data, 'db_access:DbAccess.addGenericRegister');
  }

  static Future<void> genericPost(String query) async {
    String url = '$baseIpv4/post_generico';
    Map<String, dynamic> data = {'p_query': query};
    await _httpPost(url, data, 'db_access:DbAccess.genericPost');
  }
}

class RouteContent {
  final Map<String, dynamic> data;
  final http.Response response;
  const RouteContent({required this.data, required this.response});
}