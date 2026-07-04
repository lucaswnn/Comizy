import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/snackbar_helper.dart';
import 'package:comizy/utils/validators.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final status = await AuthService.instance.recoverPasswordByEmail(
      email: _emailController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);

    switch (status) {
      case AuthRecoverPasswordStatus.success:
        SnackbarHelper.showSnackBar(
          'Enviamos um link de recuperacao para o seu e-mail.',
        );
        NavigationHelper.pop();
        break;
      case AuthRecoverPasswordStatus.invalidEmail:
        SnackbarHelper.showSnackBar('Informe um e-mail valido para continuar.');
        break;
      case AuthRecoverPasswordStatus.tooManyRequests:
        SnackbarHelper.showSnackBar(
          'Muitas tentativas detectadas. Tente novamente em instantes.',
        );
        break;
      case AuthRecoverPasswordStatus.networkRequestFailed:
        SnackbarHelper.showSnackBar(
          'Falha de conexao. Verifique sua internet e tente novamente.',
        );
        break;
      case AuthRecoverPasswordStatus.unknownError:
        SnackbarHelper.showSnackBar(
          'Nao foi possivel enviar o e-mail agora. Tente novamente mais tarde.',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text('Recuperar senha'),
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
                      'Esqueceu sua senha?',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Digite o e-mail da sua conta para receber o link de recuperacao.',
                      style: TextStyle(
                        color: AppColors.secondary.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      validator: Validators.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.secondary),
                      cursorColor: AppColors.secondary,
                      decoration: const InputDecoration(
                        hintText: 'Seu e-mail',
                        icon: Icon(Icons.email),
                        iconColor: AppColors.secondary,
                        hintStyle: TextStyle(color: AppColors.secondary),
                        filled: false,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.tertiary),
                        ),
                        errorStyle: TextStyle(color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: Text(
                        _isSubmitting ? 'Enviando...' : 'Enviar e-mail de recuperacao',
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
