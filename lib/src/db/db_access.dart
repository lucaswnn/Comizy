import 'dart:convert';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';
import 'package:http/http.dart' as http;

class DbAccess {
  static const String baseIpv4 = 'http://18.223.123.203:3000';

  // lista de produtos do servidor
  static Future<List<Map<String, dynamic>>> getProductList() async {
    String url = '$baseIpv4/lista_produtos';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('comizy: getProductList successful');
        return data;
      } else {
        print('comizy: error on getProductList: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('comizy: error on getProductList: $error');
      return [];
    }
  }

  // lista de lojas do produto atual do contexto
  static Future<List<Map<String, dynamic>>> getProductShopsList(
      Product product) async {
    String url = '$baseIpv4/lista_lojas_produto/${product.id}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('comizy: getCurrentProductShopsList successful');
        return data;
      } else {
        print(
            'comizy: error on getCurrentProductShopsList: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('comizy: error on getCurrentProductShopsList: $error');
      return [];
    }
  }

  // lista de lojas do servidor
  static Future<List<Map<String, dynamic>>> getShopList() async {
    String url = '$baseIpv4/lista_lojas';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('comizy: getShopList successful');
        return data;
      } else {
        print('comizy: error on getShopList: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('comizy: error on getShopList: $error');
      return [];
    }
  }

  // lista de lojas do produto atual do contexto
  static Future<List<Map<String, dynamic>>> getShopProductsList(
      Shop shop) async {
    String url = '$baseIpv4/lista_produtos_loja/${shop.id}';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print(
            'comizy: getShopProductsList sucessful: code ${response.statusCode}');
        return data;
      } else {
        print('comizy: error on getShopProductsList: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('comizy: error on getShopProductsList: $error');
      return [];
    }
  }

  // método para adicionar produto no servidor
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

  static Future<void> genericPost(String query) async {
    String url = '$baseIpv4/post_generico';
    Map<String, dynamic> dados = {'p_query': query};
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dados),
      );
      if (response.statusCode == 200) {
        print('Post genérico feito com sucesso');
        print('Resposta do servidor: ${response.body}');
      } else {
        print(
            'Falha no post genérico. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no post genérico: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> genericGet(String query) async {
    String url = '$baseIpv4/get_generico/$query';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('Carregado com sucesso na função genericGet');
        print(data.toString());
        return data;
      } else {
        print(
            'Falha ao buscar dados na função genericGet: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Erro de conexão na função genericGet: $error');
      return [];
    }
  }
}
