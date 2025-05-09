import 'package:flutter/material.dart';

class LandingPageFormField extends StatelessWidget {
  final TextEditingController controller;

  const LandingPageFormField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
    );
  }
}
