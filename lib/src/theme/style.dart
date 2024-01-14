import 'package:comizy/src/theme/theme.dart';
import 'package:flutter/material.dart';

class MyButtonStyles {
  var theme = MainThemeData.mainThemeData;
  static ButtonStyle searchBarHint = ButtonStyle(
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return Colors.green.withOpacity(0.5);
        }
        return null;
      },
    ),
  );
}
