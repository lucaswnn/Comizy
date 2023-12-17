import 'dart:convert';
import 'package:http/http.dart' as http;

class DbAccess {
  final String baseIpv4 = 'http://3.134.88.63:3000';

  Future<Map<String, dynamic>> getBasicData() async {
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
}
