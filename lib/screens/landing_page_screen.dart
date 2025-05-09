import 'package:comizy/services/user_change_notifier.dart';
import 'package:comizy/utils/input_formatters.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/utils/snackbar_helper.dart';
import 'package:comizy/values/app_assets.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/values/app_strings.dart';
import 'package:comizy/widgets/layout_builder_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilderWrapper(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Color.fromARGB(100, 0, 0, 0), BlendMode.darken),
            image: AssetImage(AppAssets.landingPageBackground),
            fit: BoxFit.cover,
          )),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/${AppAssets.logoNameSmall}'),
                      const SizedBox(width: 15),
                      const Flexible(
                        child: Text(
                          AppStrings.landingPageTinyTitle,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Flexible(
                            child: Text(
                              AppStrings.landingPageMainTitle,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                          Image.asset(
                            'assets/${AppAssets.simpleLogo}',
                            scale: 1.5,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        AppStrings.landingPageText,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _LandingPageForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LandingPageForm extends StatefulWidget {
  @override
  State<_LandingPageForm> createState() => _LandingPageFormState();
}

class _LandingPageFormState extends State<_LandingPageForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  String? _dropDownButtonChoice;

  final List<DropdownMenuItem<String>> _dropDownMenuEntries = const [
    DropdownMenuItem(
        value: 'São João del Rei - MG',
        child: Text(
          'São João del Rei - MG',
          style: TextStyle(color: Colors.white, fontSize: 14),
        )),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um nome válido';
    }

    return null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite um número';
    }
    if (!RegExp(r'^\(\d{2}\) 9\d{4}-\d{4}$').hasMatch(value)) {
      return 'Por favor, digite um número válido';
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
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Diga-nos seu nome',
              icon: Icon(Icons.person),
              iconColor: Colors.white,
              hintStyle: TextStyle(color: Colors.white, fontSize: 14),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              errorStyle: TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            validator: _nameValidator,
          ),
          TextFormField(
            controller: _numberController,
            inputFormatters: [TelephoneNumberInputFormatter()],
            decoration: const InputDecoration(
              hintText: 'Diga-nos seu telefone',
              icon: Icon(Icons.phone),
              iconColor: Colors.white,
              hintStyle: TextStyle(color: Colors.white, fontSize: 14),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              errorStyle: TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            validator: _numberValidator,
          ),
          DropdownButtonFormField<String>(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Escolha uma cidade';
              }
              return null;
            },
            dropdownColor: AppColors.primaryColor,
            iconEnabledColor: Colors.white,
            hint: const Text(
              'Selecione sua cidade',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor)),
              errorStyle: TextStyle(color: Colors.white),
            ),
            items: _dropDownMenuEntries,
            onChanged: (value) => setState(() => _dropDownButtonChoice = value),
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: const ButtonStyle(
                side: WidgetStatePropertyAll(BorderSide.none),
                textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 18)),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<UserChangeNotifier>().createUser(
                        name: _nameController.text,
                        number: _numberController.text,
                        city: _dropDownButtonChoice!,
                      );

                  SnackbarHelper.showSnackBar('Dados enviados com sucesso!');
                  NavigationHelper.pushReplacementNamed(AppRoutes.homePage);
                }
              },
              child: const Text(
                'Faça um teste gratuito!',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
