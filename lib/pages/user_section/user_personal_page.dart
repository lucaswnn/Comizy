import 'package:comizy/services/change_notifiers/main_user_notifier.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPersonalPage extends StatelessWidget {
  const UserPersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<MainUserNotifier>().mainUser;
    if (user == null) {
      return const InvalidRoute();
    }
    final wallet = user.wallet;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus dados pessoais'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Carteira'),
                Text('${wallet.cash} moedas'),
              ],
            ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (_, i) {
                      return ListTile(
                        leading: const Text('Pts'),
                        title: const Text('Bairro'),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.leaderboard),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      NavigationHelper.pushNamed(AppRoutes.awardsPage),
                  child: const Text('Premiações'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
