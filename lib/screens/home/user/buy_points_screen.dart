import 'package:flutter/material.dart';

class BuyPointsScreen extends StatefulWidget {
  const BuyPointsScreen({super.key});

  @override
  State<BuyPointsScreen> createState() => _BuyPointsScreenState();
}

class _BuyPointsScreenState extends State<BuyPointsScreen> {
  final TextEditingController _controller = TextEditingController();
  int _pontos = 0;
  double _valor = 0.0;

  void _calcularValor(String input) {
    final qtd = int.tryParse(input) ?? 0;
    setState(() {
      _pontos = qtd;
      _valor = qtd * 0.10; // exemplo: cada ponto custa R$0,10
    });
  }

  void _comprar() {
    debugPrint("Comprando $_pontos pontos por R\$ $_valor");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comprar Pontos")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Quantidade de pontos",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: _calcularValor,
            ),
            const SizedBox(height: 16),
            Text(
              "Valor: R\$ ${_valor.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pontos > 0 ? _comprar : null,
                child: const Text("Comprar pontos"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}