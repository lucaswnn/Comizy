import 'package:flutter/material.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Comizy'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'O Comizy conecta pessoas que querem economizar nas compras do dia a dia.\n\n'
          'Aqui você pode acompanhar produtos, registrar preços em lojas da sua região e ganhar pontos por cada colaboração válida.\n\n'
          'Nosso objetivo é tornar os preços mais transparentes e ajudar a comunidade a tomar decisões melhores na hora de comprar.',
        ),
      ),
    );
  }
}
