import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetLocationPage extends StatelessWidget {
  const SetLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolher localização'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              'Escolha uma localização para encontrar os melhores preços'),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    await context.read<LocationNotifier>().setCurrentLocation();
                    if (!context.mounted) return;
                    NavigationHelper.pop();
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: const Text(
                            'Não foi possível obter a localização atual. '
                            'Tente configurar as permissões do uso de localização.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              NavigationHelper.pop();
                            },
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Usar localização atual'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  NavigationHelper.pushNamed(AppRoutes.setLocationMapPage);
                },
                child: const Text('Selecionar no mapa'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
