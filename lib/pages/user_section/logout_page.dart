import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/services/shared_preferenes/app_preferences.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/reset_loadable_notifiers.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sair'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            resetLoadableNotifiers(context);
            final authService = AuthService.instance;
            await authService.logout();
            await AppPreferences.resetPreferences();
            NavigationHelper.pushNamedAndClearStack(AppRoutes.landingPage);
          },
          child: const Text('Sair'),
        ),
      ),
    );
  }
}
