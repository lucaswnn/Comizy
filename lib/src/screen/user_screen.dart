import 'package:comizy/src/etc/teste.dart';
import 'package:comizy/src/state/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  final List<String> entries = <String>[
    'Meu perfil',
    'Histórico de atividades',
    'Configurações'
  ];
  final List<IconData> icons = <IconData>[
    Icons.person,
    Icons.history,
    Icons.settings
  ];

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MyAppState>();
    return ListView.separated(
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(icons.elementAt(index)),
          title: Text(entries.elementAt(index)),
          onTap: () {
            if (index == 0) {
              state.addClick();
            } else {
              state.resetClick();
            }
          },
          onLongPress: () {
            if (index == 0 && state.click == 4) {
              state.resetClick();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HidedScreen()));
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
