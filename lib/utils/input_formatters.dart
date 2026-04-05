import 'package:flutter/services.dart';

class TelephoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.length > 11) text = text.substring(0, 11);

    String formatted = '';
    if (text.length >= 3) {
      formatted += '(${text.substring(0, 2)}) ';
      if (text.length >= 8) {
        formatted += '${text.substring(2, 7)}-${text.substring(7)}';
      } else if (text.length > 2) {
        formatted += text.substring(2);
      }
    } else {
      formatted = text;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '0,00',
        selection: TextSelection.collapsed(offset: 4),
      );
    }

    while (digits.length < 3) {
      digits = '0$digits';
    }

    if ((digits.startsWith('0') || digits.startsWith('00')) &&
        digits.length > 3) {
      digits = digits.substring(1);
    }

    final integerPart = digits.substring(0, digits.length - 2);
    final decimalPart = digits.substring(digits.length - 2);
    final newText = '$integerPart,$decimalPart';

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}