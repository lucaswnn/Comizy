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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Escolha sua localização para encontrar os melhores preços perto de você',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      content: const Text(
                                          'Não foi possível obter sua localização atual. '
                                          'Verifique as permissões de localização e tente novamente.'),
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
                                  asyncActionNotifier.reset();
                                  break;
                                }
                              case GPSStatus.enabled:
                                {
                                  NavigationHelper.pop();
                                  asyncActionNotifier.reset();
                                  break;
                                }
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
                          child: const Text('Usar localização atual'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      NavigationHelper.pushNamed(AppRoutes.setLocationMapPage);
                    },
                    child: const Text('Escolher no mapa'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
