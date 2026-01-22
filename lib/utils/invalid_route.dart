import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class InvalidRoute extends StatelessWidget {
  const InvalidRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Algo deu errado',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => NavigationHelper.pushNamed(AppRoutes.mainPage),
                child: const Text('Retornar')),
          ],
        ),
      ),
    );
  }
}
