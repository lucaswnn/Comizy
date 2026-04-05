import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class AuthGatePage extends StatefulWidget {
  const AuthGatePage({super.key});

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  @override
  void initState() {
    super.initState();
    _handleAuth();
  }

  void _handleAuth() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            if (AuthService.instance.currentUser == null) {
              NavigationHelper.pushNamedAndClearStack(
                AppRoutes.landingPage,
              );
            } else {
              NavigationHelper.pushNamedAndClearStack(
                AppRoutes.mainPage,
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
