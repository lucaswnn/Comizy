import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/snackbar_helper.dart';
import 'package:comizy/utils/validators.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: const _LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService.instance;
      final loginStatus = await authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      switch (loginStatus) {
        case AuthLoginStatus.success:
          NavigationHelper.pushReplacementNamed(AppRoutes.mainPage);
          break;
        case AuthLoginStatus.invalidEmail:
          SnackbarHelper.showSnackBar('O e-mail inserido é inválido.');
          break;
        case AuthLoginStatus.userDisabled:
          SnackbarHelper.showSnackBar('Este usuário foi desabilitado.');
          break;
        case AuthLoginStatus.userNotFound:
          SnackbarHelper.showSnackBar('Usuário não encontrado.');
          break;
        case AuthLoginStatus.wrongPassword:
          SnackbarHelper.showSnackBar('Senha incorreta.');
          break;
        case AuthLoginStatus.tooManyRequests:
          SnackbarHelper.showSnackBar(
              'Foram feitas muitas tentativas. Tente novamente mais tarde.');
          break;
        case AuthLoginStatus.networkRequestFailed:
          SnackbarHelper.showSnackBar(
              'Houve uma falha de conexão com a internet.');
          break;
        case AuthLoginStatus.invalidCredential:
          SnackbarHelper.showSnackBar('E-mail ou senha incorretos.');
          break;
        case AuthLoginStatus.unknownError:
          SnackbarHelper.showSnackBar(
              'Um erro inesperado ocorreu. Tente novamente mais tarde.');
          break;
      }
    }
  }

  void _openForgotPassword() {
    NavigationHelper.pushNamed(AppRoutes.forgotPasswordPage);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  TextFormField _formattedTextFormField({
    required TextEditingController controller,
    required String hintText,
    required Widget? icon,
    required String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_showPassword : false,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintText,
        icon: icon,
        iconColor: AppColors.secondary,
        suffixIcon: isPassword
            ? ExcludeFocus(
                child: IconButton(
                  onPressed: () {
                    setState(() => _showPassword = !_showPassword);
                  },
                  icon: const Icon(Icons.remove_red_eye),
                ),
              )
            : null,
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
      inputFormatters: inputFormatters,
      style: const TextStyle(color: AppColors.secondary, fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text(
          'Acesse sua conta',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Continue acompanhando preços e contribuindo com a comunidade.',
          style: TextStyle(
            color: AppColors.secondary.withValues(alpha: 0.9),
            fontSize: 14,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 22),
        _formattedTextFormField(
          controller: _emailController,
          hintText: 'Seu e-mail',
          validator: Validators.emailValidator,
          icon: const Icon(Icons.email),
        ),
        const SizedBox(height: 8),
        _formattedTextFormField(
          controller: _passwordController,
          hintText: 'Sua senha',
          validator: Validators.passwordValidator,
          icon: const Icon(Icons.lock),
          isPassword: true,
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _openForgotPassword,
            child: const Text('Esqueci minha senha'),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text(
            'Entrar',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ]),
    );
  }
}
