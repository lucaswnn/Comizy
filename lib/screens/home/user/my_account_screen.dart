import 'package:comizy/services/change_notifiers/user_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserChangeNotifier>().user!;

    return Scaffold(
      appBar: AppBar(title: const Text("Minha Conta")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(user.name),
            subtitle: const Text("Desde 01/01/1900"),
          ),
          const ListTile(
            leading: Icon(Icons.email),
            title: Text('tal@email.com'),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(user.number),
          ),
          const ListTile(
            leading: Icon(Icons.stars),
            title: Text("Pontos acumulados"),
            trailing: Text("1200"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Editar informações pessoais"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Alterar senha"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sair da conta"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}