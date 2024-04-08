import 'package:comizy/src/db/db_access.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final String type;
  const RegisterForm({super.key, required this.type});

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  late final String _hintText;

  void _setHintText() {
    if (widget.type == 'Produto') {
      _hintText =
          'Fala pra gente o nome do produto pra gente cadastrar!'
          ' Se quiser, inclua características do produto no texto';
    } else if (widget.type == 'Loja') {
      _hintText =
          'Fala pra gente o nome da loja e endereço pra gente cadastrar!';
    } else if (widget.type == 'Preço') {
      'Conta pra gente o preço certo do produto que a gente corrige!'
      ' Com sua colaboração, podemos deixar essa plataforma sempre atualizada';
    } else {
      throw '<type> precisa ser Produto, Loja ou Preço';
    }
  }

  @override
  void initState() {
    _setHintText();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 400, maxWidth: 500),
                  child: TextFormField(
                    minLines: 5,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      hintText:_hintText,
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 10) {
                        return 'O texto deve conter ao menos 10 caracteres';
                      } else if (value.length > 255) {
                        return 'Preencha no máximo 255 caracteres';
                      }
                      return null;
                    },
                    controller: _textController,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState?.validate() ?? false;

                    if (!isValid) {
                      return;
                    }
                    String text = 'Solicitação feita com sucesso!';

                    DbAccess.addGenericRegister(_textController.text).onError((error, stackTrace) {text = 'Houve uma falha no cadastro. Tente novamente mais tarde.';});

                    final snackBar = SnackBar(content: Text(text));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    Future.delayed(const Duration(milliseconds: 500))
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
