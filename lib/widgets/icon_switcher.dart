import 'package:flutter/material.dart';
import 'package:comizy/values/app_assets.dart';

class IconSwitcher extends StatefulWidget {
  const IconSwitcher({super.key});

  @override
  State<IconSwitcher> createState() => _IconSwitcherState();
}

class _IconSwitcherState extends State<IconSwitcher> {
  final _iconAssets = List<String>.generate(
      IconAssets.productIconCount, (i) => IconAssets.productIcon(i + 1));

  int _index = 0;

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _index = (_index + 1) % _iconAssets.length;
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
      child: Image.asset(
        _iconAssets[_index],
        key: ValueKey<int>(_index),
        height: 150,
      ),
    );
  }
}
