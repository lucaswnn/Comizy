import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sair'),
      ),
      body: const Center(
        child: Text('Aqui vai a lógica para sair do app.'),
      ),
    );
  }
}
