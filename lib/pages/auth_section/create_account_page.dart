import 'package:comizy/services/auth/auth_service.dart';
import 'package:comizy/services/database/database_connection.dart';
import 'package:comizy/utils/input_formatters.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/snackbar_helper.dart';
import 'package:comizy/utils/validators.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

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
              child: _CreateAccountForm(),
            ),
          ),
        ),
      ),
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

  static const String _termsSummary =
      'Ao criar sua conta, você concorda que seus dados de cadastro, localização e uso do aplicativo sejam utilizados para operar a plataforma, personalizar resultados, prevenir fraudes e melhorar a experiência. Os dados podem ser compartilhados apenas com parceiros essenciais de infraestrutura e autenticação, sempre com medidas de segurança e em conformidade com a legislação vigente. Você pode solicitar atualização ou exclusão de dados pelos canais de suporte.';

  void _setEnabled(bool? value) {
    setState(() => _enabled = value);
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Termos e Condicoes'),
        content: const SingleChildScrollView(
          child: Text(_termsSummary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService.instance;
      final createStatus = await authService.createAccount(
        email: _emailController.text,
        password: _passwordController.text,
      );
      switch (createStatus) {
        case AuthCreateAccountStatus.success:
          {
            final uid = authService.currentUser!.id;
            DatabaseConnection.instance.updateNewAccount(
              uid: uid,
              name: _nameController.text,
              number: _numberController.text,
            );

            SnackbarHelper.showSnackBar('Conta criada com sucesso!');
            NavigationHelper.pushReplacementNamed(AppRoutes.tutorialPage);
            break;
          }
        case AuthCreateAccountStatus.existingEmail:
          SnackbarHelper.showSnackBar('Este e-mail já está cadastrado.');
          break;
        case AuthCreateAccountStatus.weakPassword:
          SnackbarHelper.showSnackBar('A senha é fraca.');
          break;
        case AuthCreateAccountStatus.invalidEmail:
          SnackbarHelper.showSnackBar('O e-mail inserido é inválido.');
          break;
        case AuthCreateAccountStatus.tooManyRequests:
          SnackbarHelper.showSnackBar(
              'Foram feitas muitas tentativas. Tente novamente mais tarde.');
          break;
        case AuthCreateAccountStatus.networkRequestFailed:
          SnackbarHelper.showSnackBar(
              'Houve uma falha de conexão com a internet.');
          break;
        case AuthCreateAccountStatus.unknownError:
          SnackbarHelper.showSnackBar(
              'Um erro inesperado ocorreu. Tente novamente mais tarde.');
          break;
      }
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Crie sua conta',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comece a acompanhar produtos, contribuir com preços e subir no ranking da sua região.',
            style: TextStyle(
              color: AppColors.secondary.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 22),
          _formattedTextFormField(
            controller: _nameController,
            hintText: 'Seu nome completo',
            validator: Validators.nonEmptyValidator,
            icon: const Icon(Icons.person),
          ),
          const SizedBox(height: 8),
          _formattedTextFormField(
            controller: _numberController,
            hintText: 'Seu telefone',
            validator: Validators.numberValidator,
            icon: const Icon(Icons.phone),
            inputFormatters: [TelephoneNumberInputFormatter()],
          ),
          const SizedBox(height: 8),
          _formattedTextFormField(
            controller: _emailController,
            hintText: 'Seu e-mail',
            validator: Validators.emailValidator,
            icon: const Icon(Icons.email),
          ),
          const SizedBox(height: 8),
          _formattedTextFormField(
            controller: _passwordController,
            hintText: 'Crie uma senha',
            validator: Validators.passwordValidator,
            icon: const Icon(Icons.lock),
            isPassword: true,
          ),
          const SizedBox(height: 8),
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
              Checkbox(
                value: _enabled,
                onChanged: _setEnabled,
                fillColor: const WidgetStatePropertyAll(AppColors.secondary),
                checkColor: AppColors.primary,
                side: const BorderSide(color: AppColors.secondary),
              ),
              Flexible(
                child: TextButton(
                  onPressed: _showTerms,
                  child: const Text(
                    'Li e aceito os Termos e Condições de uso de dados.',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: (_enabled ?? false) ? _submitForm : null,
            child: const Text(
              'Criar conta',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Você poderá ajustar suas preferências e dados pessoais depois.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondary.withValues(alpha: 0.84),
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
