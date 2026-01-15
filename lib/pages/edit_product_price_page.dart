import 'package:flutter/material.dart';

class EditProductPricePage extends StatelessWidget {
  const EditProductPricePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar preço do produto'),
      ),
      body: const Center(
        child: Text('Aqui vai o formulário para editar o preço do produto.'),
      ),
    );
  }
}
