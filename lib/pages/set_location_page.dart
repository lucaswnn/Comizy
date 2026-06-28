import 'package:comizy/services/change_notifiers/async_action_notifier.dart';
import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/command/set_location_command.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/widgets/async_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetLocationPage extends StatelessWidget {
  const SetLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locationNotifier = context.read<LocationNotifier>();

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
              ChangeNotifierProvider(
                create: (_) => AsyncActionNotifier<GPSStatus>(),
                child: Consumer<AsyncActionNotifier<GPSStatus>>(
                  builder: (context, asyncActionNotifier, _) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        switch (asyncActionNotifier.result) {
                          case GPSStatus.disabled:
                          case GPSStatus.permissionDenied:
                          case GPSStatus.permissionDeniedForever:
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
                            break;
                          case GPSStatus.enabled:
                            NavigationHelper.pop();
                            break;
                          case null:
                            break;
                        }
                      },
                    );

                    final helpRequestNotifier =
                        context.read<HelpRequestNotifier>();

                    return AsyncElevatedButton(
                      notifier: asyncActionNotifier,
                      command: SetCurrentLocationCommand(
                        locationNotifier: locationNotifier,
                        helpRequestNotifier: helpRequestNotifier,
                      ),
                      child: const Text('Localização atual'),
                    );
                  },
                ),
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
