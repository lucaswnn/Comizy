import 'package:comizy/services/change_notifiers/location_notifier.dart';
import 'package:comizy/services/command/async_command.dart';

enum SetCurrentLocationResult {
  success,
  disabled,
  notPermitted,
}

class SetCurrentLocationCommand implements AsyncCommand<GPSStatus> {
  final LocationNotifier locationNotifier;
  const SetCurrentLocationCommand({required this.locationNotifier,});

  @override
  Future<GPSStatus> execute() async {
    return await locationNotifier.setCurrentLocation();
  }
}
