import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Column(
        children: [
          Text('produto'),
          Text('encontrar o melhor preço'),
        ],
      ),
    );
  }
}
