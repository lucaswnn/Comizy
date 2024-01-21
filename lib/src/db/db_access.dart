import 'dart:convert';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';
import 'package:http/http.dart' as http;

class DbAccess {
  static const String baseIpv4 = 'http://18.217.197.254:3000';

  static Future<Map<String, dynamic>> getBasicData() async {
    String url = '$baseIpv4/dados_base';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        print('Carregado com sucesso na função getBasicData');
        return json;
      } else {
        print('Falha ao buscar dados: ${response.statusCode}');
        return <String, dynamic>{};
      }
    } catch (error) {
      print('Erro de conexão: $error');
      return <String, dynamic>{};
    }
  }

  static Future<List<Map<String, dynamic>>> getProductList() async {
    String url = '$baseIpv4/lista_produtos';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('Carregado com sucesso na função getProductList');
        print(data.toString());
        return data;
      } else {
        print(
            'Falha ao buscar dados na função getProductList: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Erro de conexão na função getProductList: $error');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getShopList() async {
    String url = '$baseIpv4/lista_lojas';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('Carregado com sucesso na função getShopList');
        print(data.toString());
        return data;
      } else {
        print(
            'Falha ao buscar dados na função getShopList: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Erro de conexão na função getShopList: $error');
      return [];
    }
  }

  static Future<void> addProduct(Product product) async {
    String url = '$baseIpv4/adicionar_produto';
    Map<String, dynamic> dados = {
      'nome': product.name,
      'categoria': product.type,
    };
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dados),
      );
      if (response.statusCode == 200) {
        print('Dados enviados com sucesso');
        print('Resposta do servidor: ${response.body}');
      } else {
        print(
            'Falha ao enviar os dados. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao enviar requisição: $e');
    }
  }

  static Future<void> addShop(Shop shop) async {
    String url = '$baseIpv4/adicionar_loja';
    Map<String, dynamic> dados = {
      'nome': shop.name,
      'endereco': shop.address,
      'latitude': shop.location.latitude,
      'longitude': shop.location.longitude,
    };
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dados),
      );
      if (response.statusCode == 200) {
        print('Dados enviados com sucesso');
        print('Resposta do servidor: ${response.body}');
      } else {
        print(
            'Falha ao enviar os dados. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao enviar requisição: $e');
    }
  }
}
