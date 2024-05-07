import 'package:flutter/material.dart';

class UserOpinionScreen extends StatefulWidget {
  const UserOpinionScreen({super.key});

  @override
  UserOpinionScreenState createState() {
    return UserOpinionScreenState();
  }
}

class UserOpinionScreenState extends State<UserOpinionScreen> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
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
                      hintText:
                          'Digite aqui sua opinião, crítica ou sugestão\n(máximo 255 caracteres)',
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
                    controller: textController,
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
                    String text = 'Opinião cadastrada com sucesso!';

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
