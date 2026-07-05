import 'package:comizy/services/change_notifiers/help_request_notifier.dart';
import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/command/async_command.dart';
import 'package:latlong2/latlong.dart';

class SetCurrentLocationCommand implements AsyncCommand<GPSStatus> {
  final LocationNotifier locationNotifier;
  final HelpRequestNotifier helpRequestNotifier;

  const SetCurrentLocationCommand({
    required this.locationNotifier,
    required this.helpRequestNotifier,
  });

  @override
  Future<GPSStatus> execute() async {
    final res = await locationNotifier.setCurrentLocation();
    print('res: $res');
    if (res == GPSStatus.enabled) {
      helpRequestNotifier.neighborhoods =
          locationNotifier.getNearestNeighborhoods();
      await helpRequestNotifier.loadData(forceReload: true);
    }

    return res;
  }
}

enum SetCustomLocationResult {
  success,
}

class SetCustomLocationCommand
    implements AsyncCommand<SetCustomLocationResult> {
  final LocationNotifier locationNotifier;
  final HelpRequestNotifier helpRequestNotifier;
  final LatLng Function() getLatLngFunc;

  const SetCustomLocationCommand({
    required this.locationNotifier,
    required this.helpRequestNotifier,
    required this.getLatLngFunc,
  });

  @override
  Future<SetCustomLocationResult> execute() async {
    locationNotifier.setCustomLocation(getLatLngFunc());
    helpRequestNotifier.neighborhoods =
        locationNotifier.getNearestNeighborhoods();
    await helpRequestNotifier.loadData(forceReload: true);

    return SetCustomLocationResult.success;
  }
}
