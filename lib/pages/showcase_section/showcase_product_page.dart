import 'package:comizy/pages/connection_error_page.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/utils/navigation_helper.dart';
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
          const Text('Dados do produto'),
          ElevatedButton(
            onPressed: () {
              final status = showcaseNotifier.removeShowcaseItem(item);
              if (status == ShowcaseRemoveStatus.notEnoughTime) {
                final productInfo = showcase.showcaseItems[item]!;
                final differenceInDays = showcase.maxShowcaseSlotDays -
                    DateTime.now().difference(productInfo.addedAt).inDays;
                final dayFormatting = differenceInDays == 1 ? 'dia' : 'dias';

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text(
                        'O produto não pode ser removido da vitrine ainda. '
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
                return;
              }

              NavigationHelper.pop();
            },
            child: const Text('Remover'),
          )
        ],
      ),
    );
  }
}
