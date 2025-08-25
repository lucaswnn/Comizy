import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_assets.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/values/app_strings.dart';
import 'package:flutter/material.dart';

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({super.key});

  ElevatedButton _formattedElevatedButton(
      {required void Function()? onPressed, required String text}) {
    return ElevatedButton(
      style: const ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide.none),
        textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 15)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Color.fromARGB(100, 0, 0, 0), BlendMode.darken),
            image: AssetImage(AppAssets.landingPageBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
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
              Row(
                children: [
                  const Flexible(
                    child: Text(
                      AppStrings.landingPageMainTitle,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  Image.asset(
                    'assets/${AppAssets.simpleLogo}',
                    scale: 1.5,
                  ),
                ],
              ),
              const Text(
                AppStrings.landingPageText,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Column(children: [
                _formattedElevatedButton(
                  onPressed: () => NavigationHelper.pushNamed(AppRoutes.login),
                  text: 'Já tenho conta',
                ),
                const SizedBox(height: 5),
                _formattedElevatedButton(
                  onPressed: () =>
                      NavigationHelper.pushNamed(AppRoutes.createAccount),
                  text: 'Criar conta',
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
