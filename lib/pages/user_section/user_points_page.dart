import 'package:flutter/material.dart';

class UserPointsPage extends StatelessWidget {
  const UserPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus pontos'),
      ),
      body: const Center(
        child: Text('Aqui vai o resumo dos pontos do usuário.'),
      ),
    );
  }
}
