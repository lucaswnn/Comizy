import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/widgets/icon_switcher.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const IconSwitcher(),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              NavigationHelper.pushNamed(AppRoutes.searchPage);
            },
            child: const Text('Do que precisa hoje?'))
      ],
    );
  }
}
