import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  final List<String> entries = <String>['Meu perfil', 'Histórico de atividades', 'Configurações'];
  final List<IconData> icons = <IconData>[Icons.person, Icons.history, Icons.settings];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(icons.elementAt(index)),
          title: Text(entries.elementAt(index)),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}