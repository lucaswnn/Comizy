import 'package:comizy/pages/connection_error_page.dart';
import 'package:comizy/services/change_notifiers/main_user_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/tads/wallet.dart';
import 'package:comizy/utils/extensions.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_routes.dart';
import 'package:comizy/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  ListTile _addProductListTile() => ListTile(
        title: const Text('Adicionar produto na vitrine'),
        leading: const Icon(Icons.add),
        onTap: () => NavigationHelper.pushNamed(AppRoutes.searchPage),
      );

  ListTile _itemListTile(
    ShowcaseNotifier showcaseNotifier,
    ShowcaseItem item,
    ShowcaseItemInfo itemInfo,
  ) {
    final showcase = showcaseNotifier.showcase;
    return ListTile(
      leading: const Icon(Icons.abc),
      trailing: showcase!.isItemRemovable(item)
          ? IconButton(
              onPressed: () async {
                await showcaseNotifier.removeShowcaseItem(item);
              },
              icon: const Icon(Icons.remove),
            )
          : null,
      title: Text(item.product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${item.neighborhood}'),
          Text('Adicionado em ${itemInfo.addedAt.toShortDateString}'),
        ],
      ),
      onTap: () {
        showcaseNotifier.currentShowcaseItem = item;
        NavigationHelper.pushNamed(AppRoutes.showcaseProductPage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final showcaseNotifier = context.watch<ShowcaseNotifier>();
    final showcase = showcaseNotifier.showcase;
    if (showcase == null) {
      return const ConnectionErrorPage(
        errorMessage:
            'Erro ao carregar dados da vitrine. Vitrine não carregada.',
      );
    }
    final items = showcase.showcaseItems.keys.toList()..sort();

    return ListView.builder(
      itemCount: showcase.maxShowcaseItemsCount + 1,
      itemBuilder: (_, i) {
        if (i == showcase.maxShowcaseItemsCount) {
          return const _NewSpaceListTile();
        }
        if (i >= items.length) {
          return _addProductListTile();
        }

        final item = items[i];
        final itemInfo = showcase.showcaseItems[item]!;
        return _itemListTile(showcaseNotifier, item, itemInfo);
      },
    );
  }
}

class _NewSpaceListTile extends StatelessWidget {
  const _NewSpaceListTile();

  List<Widget> _buildReturnAction() => [
        TextButton(
          child: const Text('Voltar'),
          onPressed: () => NavigationHelper.pop(),
        ),
      ];

  List<Widget> _buildAddOrReturnActions(
    ShowcaseNotifier showcaseNotifier,
    Wallet wallet,
  ) =>
      [
        TextButton(
          child: const Text('Adicionar'),
          onPressed: () async {
            final result = await showcaseNotifier.addShowcaseSpace(wallet);
            if (result == ShowcaseAddSpaceStatus.success) {
              NavigationHelper.pop();
            }
          },
        ),
        TextButton(
          child: const Text('Voltar'),
          onPressed: () => NavigationHelper.pop(),
        )
      ];

  @override
  build(BuildContext context) {
    final user = context.read<MainUserNotifier>().mainUser;
    if (user == null) {
      return const EmptyWidget();
    }
    final wallet = user.wallet;
    final showcaseNotifier = context.read<ShowcaseNotifier>();
    final showcase = showcaseNotifier.showcase;
    if (showcase == null) {
      return const ConnectionErrorPage(
        errorMessage: 'Erro ao carregar dados da vitrine. Vitrine não carregada.',
      );
    }
    final isAddable = showcase.isSpaceAddable(wallet);
    String content;
    if (isAddable) {
      content =
          'Deseja adicionar mais um espaço por ${showcase.newSpaceCost} pontos?';
    } else {
      content =
          'Para adicionar um novo espaço, você precisa de pelo menos ${showcase.newSpaceCost} pontos.';
    }

    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text('Novo espaço'),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Adicionar novo espaço'),
            content: Text(content),
            actions: isAddable
                ? _buildAddOrReturnActions(showcaseNotifier, wallet)
                : _buildReturnAction(),
          ),
        );
      },
    );
  }
}
