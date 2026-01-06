import 'package:flutter/material.dart';

/*
class UserPageview extends StatelessWidget {
  const UserPageview({super.key});

  @override
  Widget build(BuildContext context) {
    final int points = 1200;
    final showcase = context.read<ShowcaseChangeNotifier>().showcase;
    final fixedProducts = showcase.fixedProducts;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Pontos + botões
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pontos: $points",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  
                },
                child: const Text("Pontos pendentes"),
              ),
            ),

            const SizedBox(height: 24),

            /// Produtos principais
            const Text(
              "Seus principais produtos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: fixedProducts.map((product) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            product.asset,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(product.name),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            /// Minha conta
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Abrir Minha Conta");
                },
                child: const Text("Minha conta"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

class UserPageview extends StatelessWidget {
  const UserPageview({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Meus pontos'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Minha vitrine'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Minha conta'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
