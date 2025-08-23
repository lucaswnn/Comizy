class Validators {
  static String? nonEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um nome válido';
    }

    return null;
  }

  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite um número';
    }
    if (!RegExp(r'^\(\d{2}\) 9\d{4}-\d{4}$').hasMatch(value)) {
      return 'Por favor, digite um número válido';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um email válido';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
}
