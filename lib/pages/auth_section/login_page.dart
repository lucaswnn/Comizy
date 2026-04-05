import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/snackbar_helper.dart';
import 'package:comizy/utils/validators.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
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
        iconColor: Colors.white,
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
        suffixIconColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorStyle: const TextStyle(color: Colors.white),
      ),
      validator: validator,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formattedTextFormField(
            controller: _emailController,
            hintText: 'E-mail',
            validator: Validators.emailValidator,
            icon: const Icon(Icons.email),
          ),
          _formattedTextFormField(
            controller: _passwordController,
            hintText: 'Senha',
            validator: Validators.passwordValidator,
            icon: const Icon(Icons.lock),
            isPassword: true,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: const ButtonStyle(
                side: WidgetStatePropertyAll(BorderSide.none),
                textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 15)),
              ),
              onPressed: _submitForm,
              child: const Text(
                'Entrar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
