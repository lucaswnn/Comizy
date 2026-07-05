import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/snackbar_helper.dart';
import 'package:comizy/utils/validators.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitting = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme sua senha';
    }

    if (value != _passwordController.text) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final status = await AuthService.instance.updatePassword(
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    switch (status) {
      case AuthUpdatePasswordStatus.success:
        SnackbarHelper.showSnackBar('Senha atualizada com sucesso.');
        await AuthService.instance.logout();
        if (!mounted) {
          return;
        }
        NavigationHelper.pushNamedAndClearStack(AppRoutes.loginPage);
        break;
      case AuthUpdatePasswordStatus.differentFromOldPassword:
        SnackbarHelper.showSnackBar(
          'A nova senha não pode ser igual à antiga.',
        );
        break;
      case AuthUpdatePasswordStatus.weakPassword:
        SnackbarHelper.showSnackBar('Escolha uma senha mais forte.');
        break;
      case AuthUpdatePasswordStatus.notAuthenticated:
        SnackbarHelper.showSnackBar(
          'Este link expirou ou a sessão não está mais ativa.',
        );
        NavigationHelper.pushNamedAndClearStack(AppRoutes.loginPage);
        break;
      case AuthUpdatePasswordStatus.tooManyRequests:
        SnackbarHelper.showSnackBar(
          'Muitas tentativas. Tente novamente em instantes.',
        );
        break;
      case AuthUpdatePasswordStatus.networkRequestFailed:
        SnackbarHelper.showSnackBar(
          'Falha de conexão. Verifique sua internet e tente novamente.',
        );
        break;
      case AuthUpdatePasswordStatus.unknownError:
        SnackbarHelper.showSnackBar(
          'Não foi possível atualizar a senha agora.',
        );
        break;
    }
  }

  TextFormField _passwordField({
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_showPassword,
      enableSuggestions: false,
      autocorrect: false,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintText,
        icon: const Icon(Icons.lock),
        iconColor: AppColors.secondary,
        suffixIcon: ExcludeFocus(
          child: IconButton(
            onPressed: () {
              setState(() => _showPassword = !_showPassword);
            },
            icon: const Icon(Icons.remove_red_eye),
          ),
        ),
        suffixIconColor: AppColors.secondary,
        hintStyle: const TextStyle(color: AppColors.secondary, fontSize: 14),
        filled: false,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.tertiary),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        errorStyle: const TextStyle(color: AppColors.secondary),
      ),
      validator: validator,
      style: const TextStyle(color: AppColors.secondary, fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text('Criar nova senha'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Escolha uma nova senha',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Defina uma nova senha para sua conta e volte a acessar normalmente.',
                      style: TextStyle(
                        color: AppColors.secondary.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _passwordField(
                      hintText: 'Nova senha',
                      controller: _passwordController,
                      validator: Validators.passwordValidator,
                    ),
                    const SizedBox(height: 8),
                    _passwordField(
                      hintText: 'Confirmar nova senha',
                      controller: _confirmPasswordController,
                      validator: _confirmPasswordValidator,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: Text(
                        _isSubmitting ? 'Salvando...' : 'Atualizar senha',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
