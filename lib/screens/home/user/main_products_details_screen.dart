import 'package:flutter/material.dart';

class MainProductsDetailsScreen extends StatelessWidget {
  final String nome;
  final String imagem;
  final DateTime ultimaAlteracao;

  const MainProductsDetailsScreen({
    super.key,
    required this.nome,
    required this.imagem,
    required this.ultimaAlteracao,
  });

  bool get podeAlterar {
    final diff = DateTime.now().difference(ultimaAlteracao).inDays;
    return diff > 7;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nome)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imagem,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              nome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Última alteração: ${ultimaAlteracao.day}/${ultimaAlteracao.month}/${ultimaAlteracao.year}",
            ),
            const SizedBox(height: 24),
            if (podeAlterar)
              ElevatedButton(
                onPressed: () {
                  debugPrint("Alterar produto $nome");
                },
                child: const Text("Alterar produto"),
              )
            else
              const Text(
                "Você só pode alterar este produto a cada 7 dias.",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}