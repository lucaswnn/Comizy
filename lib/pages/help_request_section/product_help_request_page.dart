import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class ProductHelpRequestPage extends StatelessWidget {
  const ProductHelpRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oportunidades para ajudar'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueAccent,
            height: 200,
            child: const Text(
                'Aqui vai o mapa de locais onde os produtos precisam de ajuda'),
          ),
          const SizedBox(height: 30),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (_, i) {
              return ListTile(
                title: const Text('Loja tal'),
                subtitle: const Text('Rua tal'),
                onTap: () {
                  NavigationHelper.pushNamed(AppRoutes.editProductPricePage);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
