import 'package:flutter/material.dart';

class UserPersonalDataPage extends StatelessWidget {
  const UserPersonalDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus dados pessoais'),
      ),
      body: const Center(
        child: Text('Aqui vai o resumo dos dados pessoais do usuário.'),
      ),
    );
  }
}
