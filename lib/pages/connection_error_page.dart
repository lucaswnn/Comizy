import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/services/shared_preferenes/app_preferences.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/reset_loadable_notifiers.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class ConnectionErrorPage extends StatelessWidget {
  final String errorMessage;
  const ConnectionErrorPage({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Não foi possível atualizar seus dados agora.\nTente novamente em instantes.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(errorMessage),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              resetLoadableNotifiers(context);
              final authService = AuthService.instance;
              await authService.logout();
              await AppPreferences.resetPreferences();
              NavigationHelper.pushNamedAndClearStack(AppRoutes.landingPage);
            },
            child: const Text('Voltar para o início'),
          )
        ],
      ),
    );
  }
}
