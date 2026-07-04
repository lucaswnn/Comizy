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
          'Aqui voce pode acompanhar produtos, registrar precos em lojas da sua regiao e ganhar pontos por cada colaboracao valida.\n\n'
          'Nosso objetivo e tornar os precos mais transparentes e ajudar a comunidade a tomar decisoes melhores na hora de comprar.',
        ),
      ),
    );
  }
}
