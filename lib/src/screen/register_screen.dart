import 'package:comizy/src/db/db_access.dart';
import 'package:comizy/src/tad/product.dart';
import 'package:comizy/src/tad/shop.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ProductRegisterScreen extends StatefulWidget {
  const ProductRegisterScreen({super.key});

  @override
  ProductRegisterScreenState createState() {
    return ProductRegisterScreenState();
  }
}

class ProductRegisterScreenState extends State<ProductRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final textNameController = TextEditingController();
  final textTypeController = TextEditingController();

  @override
  void dispose() {
    textNameController.dispose();
    textTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite o nome do produto';
                } else if (value.contains(';')) {
                  return 'Digite um valor válido';
                }
                return null;
              },
              controller: textNameController,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite a categoria do produto';
                } else if (value.contains(';')) {
                  return 'Digite um valor válido';
                }
                return null;
              },
              controller: textTypeController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DbAccess.addProduct(Product(
                        textNameController.text, 0, textTypeController.text));
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                              '${textNameController.text} + ${textTypeController.text}'),
                        );
                      },
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopRegisterScreen extends StatefulWidget {
  const ShopRegisterScreen({super.key});

  @override
  ShopRegisterScreenState createState() {
    return ShopRegisterScreenState();
  }
}

class ShopRegisterScreenState extends State<ShopRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final textNameController = TextEditingController();
  final textAddressController = TextEditingController();

  @override
  void dispose() {
    textNameController.dispose();
    textAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite o nome da loja';
                } else if (value.contains(';')) {
                  return 'Digite um valor válido';
                }
                return null;
              },
              controller: textNameController,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite o endereço da loja';
                } else if (value.contains(';')) {
                  return 'Digite um valor válido';
                }
                return null;
              },
              controller: textAddressController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DbAccess.addShop(Shop(0, textNameController.text,
                        textAddressController.text, const LatLng(1, 1)));
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                              '${textNameController.text} + ${textAddressController.text}'),
                        );
                      },
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
