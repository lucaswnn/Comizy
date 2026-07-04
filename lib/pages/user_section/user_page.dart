import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  final options = const {
    0: 'Minha conta',
    1: 'Ranking de pontos',
    2: 'Sobre o Comizy',
    3: 'Encerrar sessao',
  };

  void _navigateToOption(int option) {
    switch (option) {
      case 0:
        NavigationHelper.pushNamed(AppRoutes.userPersonalPage);
        break;
      case 1:
        NavigationHelper.pushNamed(AppRoutes.leaderboardPage);
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
          leading: Icon(
            switch (i) {
              0 => Icons.person,
              1 => Icons.leaderboard,
              2 => Icons.info,
              _ => Icons.logout,
            },
          ),
          title: Text(options[i] ?? ''),
          onTap: () => _navigateToOption(i),
        );
      },
    );
  }
}
