import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/shared_preferenes/app_preferences.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comizy/values/app_colors.dart';

class LocationAlertDialog extends StatefulWidget {
  const LocationAlertDialog({super.key});

  @override
  State<LocationAlertDialog> createState() => _LocationAlertDialogState();
}

class _LocationAlertDialogState extends State<LocationAlertDialog> {
  bool doNotShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Uso de localização'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Para melhorar sua experiência, usamos o GPS '
              'para identificar sua localização atual e mostrar ofertas próximas. '
              'O uso da localização é opcional.'),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: doNotShowAgain,
                onChanged: (v) => setState(() => doNotShowAgain = v!),
              ),
              const Expanded(
                child: Text('Não mostrar esta mensagem novamente'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Continuar',
              style: TextStyle(color: AppColors.primary)),
          onPressed: () {
            if (doNotShowAgain) {
              AppPreferences.setShowLocationMessage(false);
            }
            NavigationHelper.pop();
            context.read<LocationNotifier>().askForGPS();
            NavigationHelper.pushNamed(AppRoutes.setLocationPage);
          },
        ),
      ],
    );
  }
}
