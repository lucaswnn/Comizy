import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class ConnectionErrorPage extends StatelessWidget {
  const ConnectionErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Algo deu errado ao atualizar os dados.'),
          ElevatedButton(
            onPressed: () {
              NavigationHelper.pushNamedAndClearStack(AppRoutes.landingPage);
            },
            child: const Text('Retornar'),
          )
        ],
      ),
    );
  }
}