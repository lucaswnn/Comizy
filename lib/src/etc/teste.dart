import 'package:comizy/src/db/db_access.dart';
import 'package:flutter/material.dart';

class HidedScreen extends StatefulWidget {
  const HidedScreen({super.key});

  @override
  HidedScreenState createState() {
    return HidedScreenState();
  }
}

class HidedScreenState extends State<HidedScreen> {
  final _formKey = GlobalKey<FormState>();
  final textGetController = TextEditingController();
  final textPostController = TextEditingController();

  @override
  void dispose() {
    textGetController.dispose();
    textPostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite algo para get';
                      }
                      return null;
                    },
                    controller: textGetController,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      String text = 'error';

                      var list = DbAccess.genericGet(textGetController.text);
                      list.then((value) {
                        text = value.toString();
                        final snackBar = SnackBar(content: Text(text));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    },
                    child: const Text('Submit get'))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite algo para post';
                      }
                      return null;
                    },
                    controller: textPostController,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      String text = 'error';

                      DbAccess.genericPost(textPostController.text)
                          .whenComplete(() {
                        text = 'Feito';
                        final snackBar = SnackBar(content: Text(text));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }).onError((error, stackTrace) => text = 'erro: $error');
                    },
                    child: const Text('Submit post'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
