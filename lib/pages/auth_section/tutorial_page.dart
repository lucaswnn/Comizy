import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _steps = [
    {
      'title': 'Escolha os produtos que importam para voce',
      'description':
          'Acompanhe os precos dos itens que voce mais compra e receba atualizacoes feitas pela comunidade.',
      'image': 'https://cdn-icons-png.flaticon.com/512/3081/3081559.png'
    },
    {
      'title': 'Troque produtos quando precisar',
      'description':
          'Se quiser mudar seus itens monitorados, voce pode fazer a troca apos o periodo minimo da plataforma.',
      'image': 'https://cdn-icons-png.flaticon.com/512/484/484582.png'
    },
    {
      'title': 'Ganhe pontos ao enviar precos',
      'description':
          'Cada colaboracao valida ajuda outros usuarios e aumenta sua pontuacao no ranking local.',
      'image': 'https://cdn-icons-png.flaticon.com/512/1041/1041873.png'
    },
    {
      'title': 'Descubra novas oportunidades',
      'description':
          'Com participacao frequente, voce desbloqueia recursos e acompanha mais ofertas relevantes.',
      'image': 'https://cdn-icons-png.flaticon.com/512/2910/2910768.png'
    },
  ];

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      NavigationHelper.pushNamed(AppRoutes.mainPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          step['image']!,
                          height: 200,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          step['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          step['description']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _steps.length,
                (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
                    width: _currentPage == index ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _currentPage == _steps.length - 1 ? 'Começar' : 'Próximo',
                style: const TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
