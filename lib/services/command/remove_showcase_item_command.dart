import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/services/command/async_command.dart';
import 'package:comizy/tads/showcase.dart';

class RemoveShowcaseItemCommand implements AsyncCommand<ShowcaseRemoveStatus> {
  final ShowcaseNotifier showcaseNotifier;
  final ShowcaseItem showcaseItem;

  const RemoveShowcaseItemCommand({
    required this.showcaseNotifier,
    required this.showcaseItem,
  });

  @override
  Future<ShowcaseRemoveStatus> execute() async {
    return showcaseNotifier.removeShowcaseItem(showcaseItem);
  }
}
