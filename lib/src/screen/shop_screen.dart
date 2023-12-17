import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            ColoredBox(
              color: Colors.deepPurple,
              child: SizedBox(
                width: constraints.maxWidth - 1,
                height: 50,
                child: const Text('teste'),
              ),
            )
          ],
        );
      },
    );
  }
}
