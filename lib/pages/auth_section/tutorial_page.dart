import 'package:comizy/utils/navigation_helper.dart';
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
      'title': 'Escolha 2 produtos',
      'description':
          'Você pode acompanhar os preços de 2 produtos à sua escolha, por tempo indeterminado.',
      'image': 'https://cdn-icons-png.flaticon.com/512/3081/3081559.png'
    },
    {
      'title': 'Troque após 1 semana',
      'description':
          'Se quiser trocar os produtos, aguarde 1 semana desde a última troca.',
      'image': 'https://cdn-icons-png.flaticon.com/512/484/484582.png'
    },
    {
      'title': 'Ganhe pontos cadastrando preços',
      'description':
          'Ao cadastrar preços de produtos, você ajuda a comunidade e ganha pontos!',
      'image': 'https://cdn-icons-png.flaticon.com/512/1041/1041873.png'
    },
    {
      'title': 'Desbloqueie produtos ocultos',
      'description':
          'A cada 2 preços validados, você desbloqueia 1 produto oculto por uma semana.',
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
                          ? Colors.blue
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
