import 'package:comizy/pages/connection_error_page.dart';
import 'package:comizy/services/change_notifiers/async_action_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/services/command/remove_showcase_item_command.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/widgets/async_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowcaseProductPage extends StatelessWidget {
  const ShowcaseProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final showcaseNotifier = context.read<ShowcaseNotifier>();
    final showcase = showcaseNotifier.showcase;
    if (showcase == null) {
      return const ConnectionErrorPage();
    }
    final item = showcaseNotifier.currentShowcaseItem;
    if (item == null) {
      return const InvalidRoute();
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text('Informacoes do produto na vitrine'),
          ChangeNotifierProvider(
            create: (_) => AsyncActionNotifier<ShowcaseRemoveStatus>(),
            child: Consumer<AsyncActionNotifier<ShowcaseRemoveStatus>>(
              builder: (context, asyncActionNotifier, _) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    switch (asyncActionNotifier.result) {
                      case ShowcaseRemoveStatus.success:
                        NavigationHelper.pop();
                        break;

                      case ShowcaseRemoveStatus.notEnoughTime:
                        {
                          final productInfo = showcase.showcaseItems[item]!;
                          final differenceInDays =
                              showcase.maxShowcaseSlotDays -
                                  DateTime.now()
                                      .difference(productInfo.addedAt)
                                      .inDays;
                          final dayFormatting =
                              differenceInDays == 1 ? 'dia' : 'dias';
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              content: Text(
                                  'Este produto ainda nao pode ser removido da vitrine. '
                                  'Aguarde mais $differenceInDays $dayFormatting.'),
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
                      case ShowcaseRemoveStatus.itemNotFound:
                        throw 'Item não encontrado';
                      case ShowcaseRemoveStatus.error:
                        throw '${asyncActionNotifier.error}';
                      case null:
                        throw 'Algum erro aconteceu';
                    }
                  },
                );

                return AsyncElevatedButton(
                  notifier: asyncActionNotifier,
                  command: RemoveShowcaseItemCommand(
                    showcaseNotifier: showcaseNotifier,
                    showcaseItem: item,
                  ),
                  child: const Text('Remover da vitrine'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
