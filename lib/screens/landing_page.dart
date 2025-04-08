import 'package:comizy/values/assets.dart';
import 'package:comizy/values/strings.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 6, 44, 85),
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(Assets.landingPageBackground),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/${Assets.logoNomeSmall}'),
                    const SizedBox(width: 15),
                    const Flexible(
                      child: Text(
                        Strings.landingPageTitle,
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
                    Image.asset('assets/${Assets.logoSimples}'),
                    const SizedBox(height: 20),
                    const Text(
                      Strings.landingPageText,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 20),
                        Container(
                          color: Colors.white,
                          width: 120,
                          height: 40,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
