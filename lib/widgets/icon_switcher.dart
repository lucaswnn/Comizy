import 'package:flutter/material.dart';

class IconSwitcher extends StatefulWidget {
  const IconSwitcher({super.key});

  @override
  State<IconSwitcher> createState() => _IconSwitcherState();
}

class _IconSwitcherState extends State<IconSwitcher> {
  final icons = const [
    Icons.book,
    Icons.movie,
    Icons.music_note,
    Icons.videogame_asset,
    Icons.tv,
    Icons.podcasts,
  ];

  int index = 0;

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        index = (index + 1) % icons.length;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Icon(
        icons[index],
        key: ValueKey(icons[index]),
        size: 48,
      ),
    );
  }
}
