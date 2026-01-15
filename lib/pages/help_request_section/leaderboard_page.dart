import 'package:comizy/services/change_notifiers/other_users_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final helpers = context.read<OtherUsersNotifier>().otherUsers..sort();
    final leaderboardSize = 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking de Ajudantes'),
      ),
      body: ListView.builder(
        itemCount: leaderboardSize,
        itemBuilder: (_, i) {
          final helper = helpers[i];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(helper.name),
            subtitle: Text('Pontos: ${helper.points}'),
          );
        },
      ),
    );
  }
}
