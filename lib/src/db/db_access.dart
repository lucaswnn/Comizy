import 'dart:convert';
import 'package:http/http.dart' as http;

class DbAccess {
  static const String baseIpv4 = 'http://3.134.88.63:3000';

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
        final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print('Carregado com sucesso na função getProductList');
        return data;
      } else {
        print('Falha ao buscar dados na função getProductList: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Erro de conexão na função getProductList: $error');
      return [];
    }
  }
}
