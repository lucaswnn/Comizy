import 'package:comizy/services/change_notifiers/user_change_notifier.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/snackbar_helper.dart';
import 'package:comizy/utils/validators.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _LoginForm(),
        ),
      ),
      backgroundColor: AppColors.primaryColor,
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<UserChangeNotifier>().createUser(
            name: 'fulano',
            number: 'numero',
          );

      SnackbarHelper.showSnackBar('Login feito com sucesso!');
      NavigationHelper.pushReplacementNamed(AppRoutes.homePage);
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
          borderSide: BorderSide(color: AppColors.secondaryColor),
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
        mainAxisAlignment: MainAxisAlignment.center,
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
          TextButton(
            onPressed: () =>
                NavigationHelper.pushNamed(AppRoutes.forgotPassword),
            child: const Text(
              'Esqueci minha senha',
              style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white),
            ),
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
