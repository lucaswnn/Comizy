import 'package:comizy/src/theme/theme.dart';
import 'package:flutter/material.dart';

class MyButtonStyles {
  var theme = MainThemeData.mainThemeData;
  static ButtonStyle searchBarHint = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.blue;
        }
        if (states.contains(MaterialState.focused)) {
          return Colors.green;
        }
        return null;
      },
    ),
  );
}
