import 'package:flutter/material.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o app'),
      ),
      body: const Center(
        child: Text('Aqui vão as informações sobre o app.'),
      ),
    );
  }
}
