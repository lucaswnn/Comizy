import 'package:comizy/theme/theme.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Material(
      color: AppColors.primary,
      child: Center(
        child: _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  // tamanho dos botões
  static const _formButtonStyle = ButtonStyle(
    fixedSize: MaterialStatePropertyAll<Size>(Size(100, 30)),
    padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(2)),
  );

  // botões
  List<ElevatedButton> _formButtons(BuildContext context) {
    return [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/init_load');
        },
        style: _formButtonStyle,
        child: const Text('Entrar'),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/register');
        },
        style: _formButtonStyle,
        child: const Text('Cadastrar'),
      )
    ];
  }

  // textFormFields
  List<TextFormField> _textFormFields() {
    return [
      TextFormField(
        style: AppText.alternativeTextStyle,
        decoration: const InputDecoration(hintText: 'e-mail'),
      ),
      TextFormField(
        style: AppText.alternativeTextStyle,
        decoration: const InputDecoration(hintText: 'senha'),
        obscureText: true,
      ),
    ];
  }

  // textButton para redefinição de senha
  TextButton _forgotPasswordButton() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        'Esqueci minha senha',
        style: TextStyle(color: AppColors.tertiary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(const Size(300, 250)),
      child: Card(
        color: Theme.of(context).colorScheme.background,
        surfaceTintColor: AppColors.lightNeutral,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._textFormFields(),
                  const SizedBox(height: 5),
                  _forgotPasswordButton(),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _formButtons(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
