enum _PasswordItems {
  uppercase,
  lowercase,
  digit,
  sixCharacters,
  specialCharacter,
}

class Validators {
  static String? nonEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe um nome valido';
    }

    return null;
  }

  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe um telefone';
    }
    if (!RegExp(r'^\(\d{2}\) 9\d{4}-\d{4}$').hasMatch(value)) {
      return 'Use o formato (99) 99999-9999';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe um e-mail valido';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Informe um e-mail valido';
    }
    return null;
  }

  static const String passwordSpecialCharacters = r'.,_*&!?;@#$%';

  static const Map<_PasswordItems, String> _passwordHints = {
    _PasswordItems.uppercase: 'Pelo menos uma letra maiúscula',
    _PasswordItems.lowercase: 'Pelo menos uma letra minúscula',
    _PasswordItems.digit: 'Pelo menos um número',
    _PasswordItems.sixCharacters: 'Pelo menos 6 caracteres',
    _PasswordItems.specialCharacter:
        'Pelo menos um caracter especial ($passwordSpecialCharacters)',
  };

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Crie uma senha';
    }
    if (!value.contains(RegExp('^[A-Za-z0-9$passwordSpecialCharacters]+\$'))) {
      return 'Use apenas letras, numeros e os caracteres especiais: $passwordSpecialCharacters';
    }

    final passwordItems = <_PasswordItems>[];
    if (value.length < 6) {
      passwordItems.add(_PasswordItems.sixCharacters);
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      passwordItems.add(_PasswordItems.uppercase);
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      passwordItems.add(_PasswordItems.lowercase);
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      passwordItems.add(_PasswordItems.digit);
    }
    if (!value.contains(RegExp('[$passwordSpecialCharacters]'))) {
      passwordItems.add(_PasswordItems.specialCharacter);
    }

    if (passwordItems.isNotEmpty) {
      return passwordItems.fold<String>('Sua senha precisa ter:\n',
          (str, item) {
        return '$str\n- ${_passwordHints[item]}';
      });
    }
    return null;
  }
}
