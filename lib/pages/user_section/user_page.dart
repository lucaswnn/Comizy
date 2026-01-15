import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  final options = const {
    0: 'Meus pontos: ao clicar, mostra pontos, placar e premiações',
    1: 'Dados pessoais: ao clicar, leva para resumo dos dados pessoais e dá opção de editar nick e icone',
    2: 'Sobre o app: ao clicar, mostra informações sobre o app e o propósito, versão, termos de uso',
    3: 'Sair',
  };

  void _navigateToOption(int option) {
    switch (option) {
      case 0:
        NavigationHelper.pushNamed(AppRoutes.userPointsPage);
        break;
      case 1:
        NavigationHelper.pushNamed(AppRoutes.userPersonalDataPage);
        break;
      case 2:
        NavigationHelper.pushNamed(AppRoutes.appInfoPage);
        break;
      case 3:
        NavigationHelper.pushNamed(AppRoutes.logoutPage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (_, i) {
        return ListTile(
          leading: const Icon(Icons.abc),
          title: Text(options[i] ?? ''),
          onTap: () => _navigateToOption(i),
        );
      },
    );
  }
}
