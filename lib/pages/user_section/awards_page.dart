import 'package:flutter/material.dart';

class AwardsPage extends StatelessWidget {
  const AwardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premiações'),
      ),
      body: const Center(
        child: Text('Minhas premiações'),
      ),
    );
  }
}
