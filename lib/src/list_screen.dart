import 'package:comizy/src/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListScreen extends StatefulWidget {
  ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Product> products = [
    Product('Produto 1', 1, 'Tipo 1'),
    Product('Produto 2', 2, 'Tipo 2'),
    Product('Produto 3', 3, 'Tipo 2'),
    Product('Produto 4', 4, 'Tipo 3'),
    Product('Produto 5', 5, 'Tipo 3')
  ];

  String addon = 'a';

  Future<void> getDataFromWeb() async {
    String apiUrl = 'http://3.134.88.63:3000/dados';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          addon = response.body;
        });
      } else {
        print('Falha ao buscar dados: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro de conexão: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFromWeb().then((value) {
      products.add(Product(addon, 1, 'Tipo 1'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              products.elementAt(index).name,
            ),
            leading: Icon(products.elementAt(index).iconData),
          );
        });
  }
}
