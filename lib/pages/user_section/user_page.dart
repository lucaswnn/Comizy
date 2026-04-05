import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  final options = const {
    0: 'Minha conta',
    1: 'Sobre o app',
    2: 'Sair',
  };

  void _navigateToOption(int option) {
    switch (option) {
      case 0:
        NavigationHelper.pushNamed(AppRoutes.userPersonalPage);
        break;
      case 1:
        NavigationHelper.pushNamed(AppRoutes.appInfoPage);
        break;
      case 2:
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
