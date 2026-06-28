import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/shared_preferenes/app_preferences.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        children: [
          const Text('Para melhorar sua experiência, utilizamos o GPS '
              'para encontrar sua localização atual. '
              'O uso da localização não é obrigatório.'),
          const SizedBox(height: 10),
          Checkbox(
            value: doNotShowAgain,
            onChanged: (v) => setState(() => doNotShowAgain = v!),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Continuar'),
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
