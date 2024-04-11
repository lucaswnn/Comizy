import 'package:comizy/src/etc/teste.dart';
import 'package:comizy/src/screen/about_us_screen.dart';
import 'package:comizy/src/screen/user_opinion_screen.dart';
import 'package:comizy/src/state/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  final List<String> entries = <String>[
    'Sobre nós',
    'Dê sua opinião',
    'Em breve...'
  ];
  final List<IconData> icons = <IconData>[
    Icons.accessibility,
    Icons.mode_comment,
    Icons.history,
  ];

  ListTile _listTile(BuildContext context, MyAppState state, int index) {
    return ListTile(
      leading: Icon(icons.elementAt(index)),
      title: Text(entries.elementAt(index)),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      onTap: () {
        switch (index) {
          case 0:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()));
            break;
          case 1:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserOpinionScreen()));
            break;
          case 2:
            state.addClick();
            break;
          default:
            state.resetClick();
        }
      },
      onLongPress: () {
        switch (index) {
          case 2:
            if (state.click == 4) {
              state.resetClick();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HidedScreen()));
            }
            break;
          default:
            state.resetClick();
        }
        if (index == 2 && state.click == 4) {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MyAppState>();
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return _listTile(context, state, index);
        },
      ),
    );
  }
}
