import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/values/app_assets.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.logoNameSmall),
                  const SizedBox(width: 15),
                  const Flexible(
                    child: Text(
                      'Comunidade colaborativa de preços',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'Economize nas compras do dia a dia com informações reais do seu bairro.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Cadastre preços, acompanhe produtos e ganhe pontos ajudando outras pessoas a comprar melhor.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(AppAssets.simpleLogo,
                    scale: 1.5,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        NavigationHelper.pushNamed(AppRoutes.loginPage),
                    child: const Text('Entrar na minha conta'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(color: AppColors.secondary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () =>
                        NavigationHelper.pushNamed(AppRoutes.createAccountPage),
                    child: const Text('Criar conta grátis'),
                  ),
                ],
              ),
              Text(
                'Ao continuar, você concorda com nossos termos e política de privacidade.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.86),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
