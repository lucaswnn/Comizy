import 'package:comizy/values/app_colors.dart';
import 'package:comizy/values/app_general_values.dart';
import 'package:flutter/material.dart';

class LayoutBuilderWrapper extends StatelessWidget {
  final Widget child;

  const LayoutBuilderWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundColor,
      child: LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxWidth > AppGeneralValues.maxWindowWidth) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.loose(
                  const Size(
                    AppGeneralValues.maxWindowWidth,
                    AppGeneralValues.maxWindowHeight,
                  ),
                ),
                child: child,
              ),
            );
          }
          return child;
        },
      ),
    );
  }
}
