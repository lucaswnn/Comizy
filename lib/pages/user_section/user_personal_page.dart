import 'package:comizy/services/change_notifiers/main_user_notifier.dart';
import 'package:comizy/utils/invalid_route.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('Nome'),
              subtitle: Text(user.name),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Número'),
              subtitle: Text(user.number),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text('Carteira'),
              subtitle: Text('${wallet.cash} moedas'),
            ),
          ],
        ),
      ),
    );
  }
}
