import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/services/command/async_command.dart';
import 'package:comizy/tads/showcase.dart';

class AddShowcaseItemCommand implements AsyncCommand<ShowcaseAddItemStatus> {
  final ShowcaseNotifier showcaseNotifier;
  final ShowcaseItem showcaseItem;

  const AddShowcaseItemCommand({
    required this.showcaseNotifier,
    required this.showcaseItem,
  });

  @override
  Future<ShowcaseAddItemStatus> execute() async {
    final res = await showcaseNotifier.addShowcaseItem(showcaseItem);
    
    return res;
  }
}