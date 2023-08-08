import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  ListScreen({super.key});

  final List<String> entries = <String>[
    'Produto 1',
    'Produto 2',
    'Produto 3',
    'Produto 4',
    'Produto 5'
  ];
  final List<IconData> icons = <IconData>[
    Icons.breakfast_dining,
    Icons.book,
    Icons.medication,
    Icons.lunch_dining,
    Icons.dinner_dining
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              entries.elementAt(index),
            ),
            leading: Icon(icons.elementAt(index)),
          );
        });
  }
}
