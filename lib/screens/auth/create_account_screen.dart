import 'package:comizy/services/change_notifiers/user_change_notifier.dart';
import 'package:comizy/utils/input_formatters.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/snackbar_helper.dart';
import 'package:comizy/utils/validators.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _CreateAccountForm(),
        ),
      ),
      backgroundColor: AppColors.primaryColor,
    );
  }
}

class _CreateAccountForm extends StatefulWidget {
  @override
  State<_CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<_CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool? _enabled = false;
  bool _showPassword = false;

  void _setEnabled(bool? value) {
    setState(() => _enabled = value);
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Termos de Uso'),
        content: const SingleChildScrollView(
          child: Text(AppStrings.termsOfUse),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<UserChangeNotifier>().createUser(
            name: _nameController.text,
            number: _numberController.text,
          );

      SnackbarHelper.showSnackBar('Dados enviados com sucesso!');
      NavigationHelper.pushReplacementNamed(AppRoutes.tutorial);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }
    if (value != _passwordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formattedTextFormField(
            controller: _nameController,
            hintText: 'Diga-nos seu nome',
            validator: Validators.nonEmptyValidator,
            icon: const Icon(Icons.person),
          ),
          _formattedTextFormField(
            controller: _numberController,
            hintText: 'Diga-nos seu telefone',
            validator: Validators.numberValidator,
            icon: const Icon(Icons.phone),
            inputFormatters: [TelephoneNumberInputFormatter()],
          ),
          _formattedTextFormField(
            controller: _emailController,
            hintText: 'Diga-nos seu email',
            validator: Validators.emailValidator,
            icon: const Icon(Icons.email),
          ),
          _formattedTextFormField(
            controller: _passwordController,
            hintText: 'Crie uma senha',
            validator: Validators.passwordValidator,
            icon: const Icon(Icons.lock),
            isPassword: true,
          ),
          _formattedTextFormField(
            controller: _confirmPasswordController,
            hintText: 'Confirme sua senha',
            validator: _confirmPasswordValidator,
            icon: const Icon(Icons.lock),
            isPassword: true,
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Checkbox(value: _enabled, onChanged: _setEnabled),
              Flexible(
                child: TextButton(
                  onPressed: _showTerms,
                  child: const Text(AppStrings.acceptTermsOfUse),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: const ButtonStyle(
                side: WidgetStatePropertyAll(BorderSide.none),
                textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 15)),
              ),
              onPressed: (_enabled ?? false) ? _submitForm : null,
              child: const Text(
                'Cadastrar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
