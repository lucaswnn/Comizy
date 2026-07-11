import 'package:comizy/pages/connection_error_page.dart';
import 'package:comizy/services/change_notifiers/async_action_notifier.dart';
import 'package:comizy/services/change_notifiers/market_notifier.dart';
import 'package:comizy/services/change_notifiers/showcase_notifier.dart';
import 'package:comizy/services/command/remove_showcase_item_command.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:comizy/utils/extensions.dart';
import 'package:comizy/utils/invalid_route.dart';
import 'package:comizy/utils/navigation_helper.dart';
import 'package:comizy/values/app_colors.dart';
import 'package:comizy/widgets/async_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowcaseProductPage extends StatefulWidget {
  const ShowcaseProductPage({super.key});

  @override
  State<ShowcaseProductPage> createState() => _ShowcaseProductPageState();
}

class _ShowcaseProductPageState extends State<ShowcaseProductPage> {
  ShowcaseRemoveStatus? _lastShownRemoveResult;

  String _formatPrice(OfferInfo info) {
    return 'R\$${info.price.value.toStringAsFixed(2).replaceFirst('.', ',')} (${info.price.unit})';
  }

  Color _freshnessColor(OfferInfo info) {
    if (!info.needsUpdate) {
      return Colors.green.shade600;
    }

    final ageInDays = DateTime.now().difference(info.lastUpdated).inDays;
    if (ageInDays <= 3) {
      return Colors.amber.shade700;
    }
    return Colors.orange.shade700;
  }

  String _freshnessLabel(OfferInfo info) {
    if (!info.needsUpdate) {
      return 'Alta probabilidade de estar correto';
    }

    final ageInDays = DateTime.now().difference(info.lastUpdated).inDays;
    if (ageInDays <= 3) {
      return 'Atualização recomendada em breve';
    }
    return 'Preço possivelmente desatualizado';
  }

  String _shopLocationLabel(Offer offer) {
    return '${offer.shop.name} - ${offer.shop.neighborhood.name}';
  }

  Set<int> _eligibleNeighborhoodIds(Showcase showcase, ShowcaseItem item) {
    return showcase.showcaseItems.keys
        .where((slot) => slot.product == item.product)
        .map((slot) => slot.neighborhood.id)
        .toSet();
  }

  List<MapEntry<Offer, OfferInfo>> _offersForEligibleNeighborhoods({
    required Showcase showcase,
    required ShowcaseItem item,
    required MarketNotifier marketNotifier,
  }) {
    final eligibleNeighborhoodIds = _eligibleNeighborhoodIds(showcase, item);
    final offersByProduct = marketNotifier.market.offersByProduct(item.product);
    final offers = offersByProduct.entries.where((entry) {
      final neighborhoodId = entry.key.shop.neighborhood.id;
      return eligibleNeighborhoodIds.contains(neighborhoodId);
    }).toList();

    offers.sort((a, b) {
      final byPrice = a.value.price.value.compareTo(b.value.price.value);
      if (byPrice != 0) {
        return byPrice;
      }
      return b.value.lastUpdated.compareTo(a.value.lastUpdated);
    });

    return offers;
  }

  Widget _metricTile({
    required String title,
    required String value,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(11, 71, 136, 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(icon, size: 16, color: iconColor ?? AppColors.primary),
              if (icon != null) const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(subtitle),
          ]
        ],
      ),
    );
  }

  Widget _buildHeaderCard({
    required ShowcaseItem item,
    required int eligibleNeighborhoodCount,
  }) {
    final productVariation = item.product.productType.productVariation;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            Color.fromRGBO(8, 45, 88, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            item.product.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${item.product.productType.mainCategory} (${item.product.productType.subcategory})',
            style: const TextStyle(color: Colors.white70),
          ),
          if (productVariation != null && productVariation.isDefined) ...[
            const SizedBox(height: 6),
            Text(
              'Variação: ${productVariation.label}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            'Bairro pesquisado: ${item.neighborhood.name}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(List<MapEntry<Offer, OfferInfo>> offers) {
    if (offers.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumo de preços',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              Text(
                'Ainda não há ofertas para este produto nos bairros escolhidos.',
              ),
            ],
          ),
        ),
      );
    }

    final minOffer = offers.first;
    final maxOffer = offers.last;
    final newestOffer = offers.reduce(
      (a, b) => a.value.lastUpdated.isAfter(b.value.lastUpdated) ? a : b,
    );

    if (offers.length == 1) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumo de preços',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _metricTile(
                title: 'Preço registrado',
                value: _formatPrice(minOffer.value),
                subtitle: _shopLocationLabel(minOffer.key),
                icon: Icons.sell,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _freshnessColor(newestOffer.value)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _freshnessColor(newestOffer.value),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.update,
                      color: _freshnessColor(newestOffer.value),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Última atualização em ${newestOffer.value.lastUpdated.toShortDateString} - ${_freshnessLabel(newestOffer.value)}',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    final total = offers.fold<double>(
      0,
      (sum, entry) => sum + entry.value.price.value,
    );
    final average = total / offers.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo de preços',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _metricTile(
              title: 'Menor preço',
              value: _formatPrice(minOffer.value),
              subtitle: _shopLocationLabel(minOffer.key),
              icon: Icons.trending_down,
              iconColor: Colors.green.shade600,
            ),
            const SizedBox(height: 10),
            _metricTile(
              title: 'Maior preço',
              value: _formatPrice(maxOffer.value),
              subtitle: _shopLocationLabel(maxOffer.key),
              icon: Icons.trending_up,
              iconColor: Colors.red.shade600,
            ),
            if (offers.length > 1) ...[
              const SizedBox(height: 10),
              _metricTile(
                title: 'Preço médio',
                value:
                    'R\$${average.toStringAsFixed(2).replaceFirst('.', ',')} (${minOffer.value.price.unit})',
                icon: Icons.functions,
              ),
            ],
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    _freshnessColor(newestOffer.value).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _freshnessColor(newestOffer.value),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.update,
                    color: _freshnessColor(newestOffer.value),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Última atualização em ${newestOffer.value.lastUpdated.toShortDateString} - ${_freshnessLabel(newestOffer.value)}',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOffersList(List<MapEntry<Offer, OfferInfo>> offers) {
    if (offers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Ofertas encontradas também em',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            ...offers.map((entry) {
              final offer = entry.key;
              final info = entry.value;
              final statusColor = _freshnessColor(info);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 0,
                color: const Color.fromRGBO(11, 71, 136, 0.04),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: statusColor.withValues(alpha: 0.2),
                    child: Icon(Icons.store, color: statusColor),
                  ),
                  title: Text(offer.shop.name),
                  subtitle: Text(
                    '${offer.shop.neighborhood.name} • Atualizado em ${info.lastUpdated.toShortDateString}',
                  ),
                  trailing: Text(
                    _formatPrice(info),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  void _showSimpleDialog(String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              NavigationHelper.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleRemoveResult({
    required AsyncActionNotifier<ShowcaseRemoveStatus> asyncActionNotifier,
    required Showcase showcase,
    required ShowcaseItem item,
  }) {
    final result = asyncActionNotifier.result;
    if (result == null || result == _lastShownRemoveResult) {
      return;
    }

    _lastShownRemoveResult = result;

    switch (result) {
      case ShowcaseRemoveStatus.success:
        NavigationHelper.pop();
        break;
      case ShowcaseRemoveStatus.notEnoughTime:
        final productInfo = showcase.showcaseItems[item]!;
        final differenceInDays = showcase.maxShowcaseSlotDays -
            DateTime.now().difference(productInfo.addedAt).inDays;
        final remainingDays = differenceInDays < 0 ? 0 : differenceInDays;
        final dayFormatting = remainingDays == 1 ? 'dia' : 'dias';
        _showSimpleDialog(
          'Este produto ainda nao pode ser removido da vitrine. Aguarde mais $remainingDays $dayFormatting.',
        );
        break;
      case ShowcaseRemoveStatus.itemNotFound:
        _showSimpleDialog('Item não encontrado.');
        break;
      case ShowcaseRemoveStatus.error:
        _showSimpleDialog('Falha ao remover o item da vitrine.');
        break;
    }
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
    final item = showcaseNotifier.currentShowcaseItem;
    if (item == null) {
      return const InvalidRoute();
    }

    final marketNotifier = context.watch<MarketNotifier>();
    List<MapEntry<Offer, OfferInfo>> offers;
    try {
      offers = _offersForEligibleNeighborhoods(
        showcase: showcase,
        item: item,
        marketNotifier: marketNotifier,
      );
    } on NullMarketException {
      return const ConnectionErrorPage(
        errorMessage: 'Erro ao carregar ofertas de mercado.',
      );
    }

    final eligibleNeighborhoodCount =
        _eligibleNeighborhoodIds(showcase, item).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produto na vitrine'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildHeaderCard(
                      item: item,
                      eligibleNeighborhoodCount: eligibleNeighborhoodCount,
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryCard(offers),
                    const SizedBox(height: 6),
                    _buildOffersList(offers),
                  ],
                ),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => AsyncActionNotifier<ShowcaseRemoveStatus>(),
              child: Consumer<AsyncActionNotifier<ShowcaseRemoveStatus>>(
                builder: (context, asyncActionNotifier, _) {
                  final result = asyncActionNotifier.result;
                  if (result == null) {
                    _lastShownRemoveResult = null;
                  }

                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      _handleRemoveResult(
                        asyncActionNotifier: asyncActionNotifier,
                        showcase: showcase,
                        item: item,
                      );
                    },
                  );

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: AsyncElevatedButton(
                        notifier: asyncActionNotifier,
                        command: RemoveShowcaseItemCommand(
                          showcaseNotifier: showcaseNotifier,
                          showcaseItem: item,
                        ),
                        child: const Text('Remover da vitrine'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
