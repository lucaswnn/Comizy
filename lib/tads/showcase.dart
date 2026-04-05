import 'dart:collection';

import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/wallet.dart';
import 'package:comizy/tads/neighborhood.dart';

enum ShowcaseAddSpaceStatus {
  success,
  notEnoughCash,
  error,
}

enum ShowcaseAddItemStatus {
  success,
  alreadyExists,
  limitReached,
  error,
}

enum ShowcaseRemoveStatus {
  success,
  itemNotFound,
  notEnoughTime,
  error,
}

class Showcase {
  final Map<ShowcaseItem, ShowcaseItemInfo> _showcaseItems;
  int maxShowcaseItemsCount;
  final int maxShowcaseSlotDays;
  final int newSpaceCost;

  Showcase({
    required Map<ShowcaseItem, ShowcaseItemInfo> showcaseItems,
    required this.maxShowcaseItemsCount,
    required this.newSpaceCost,
    required this.maxShowcaseSlotDays,
  })  : _showcaseItems = showcaseItems;

  UnmodifiableMapView<ShowcaseItem, ShowcaseItemInfo> get showcaseItems =>
      UnmodifiableMapView(_showcaseItems);

  bool get isShowcaseFull => _showcaseItems.length >= maxShowcaseItemsCount;

  bool isItemRemovable(ShowcaseItem item) {
    final addedAt = _showcaseItems[item]!.addedAt;
    return DateTime.now().difference(addedAt).inDays >= maxShowcaseSlotDays;
  }

  bool containsProduct(Product? product) {
    return _showcaseItems.keys.any((item) => item.product == product);
  }

  ShowcaseAddItemStatus addShowcaseItem(ShowcaseItem item) {
    if (_showcaseItems.length >= maxShowcaseItemsCount) {
      return ShowcaseAddItemStatus.limitReached;
    }
    if (_showcaseItems.containsKey(item)) {
      return ShowcaseAddItemStatus.alreadyExists;
    }
    final now = DateTime.now();
    _showcaseItems[item] = ShowcaseItemInfo(
      addedAt: now,
      expiresAt: now.add(Duration(days: maxShowcaseSlotDays)),
    );
    return ShowcaseAddItemStatus.success;
  }

  bool isSpaceAddable(Wallet wallet) => wallet.cash >= newSpaceCost;

  ShowcaseAddSpaceStatus addShowcaseSpace(Wallet wallet) {
    if (isSpaceAddable(wallet)) {
      wallet.removeCash(newSpaceCost);
      maxShowcaseItemsCount++;
      return ShowcaseAddSpaceStatus.success;
    }

    return ShowcaseAddSpaceStatus.notEnoughCash;
  }

  ShowcaseRemoveStatus removeShowcaseItem(ShowcaseItem item) {
    if (!_showcaseItems.containsKey(item)) {
      return ShowcaseRemoveStatus.itemNotFound;
    }
    final addedAt = _showcaseItems[item]!.addedAt;
    if (DateTime.now().difference(addedAt).inDays < maxShowcaseSlotDays) {
      return ShowcaseRemoveStatus.notEnoughTime;
    }
    _showcaseItems.remove(item);
    return ShowcaseRemoveStatus.success;
  }

  Map<ShowcaseItem, ShowcaseItemInfo> filterByProduct(Product product) {
    return Map<ShowcaseItem, ShowcaseItemInfo>.fromEntries(
        _showcaseItems.entries.where((e) => e.key.product == product));
  }
}

class ShowcaseItem implements Comparable<ShowcaseItem> {
  final Product product;
  final Neighborhood neighborhood;

  const ShowcaseItem({
    required this.product,
    required this.neighborhood,
  });

  @override
  int compareTo(ShowcaseItem other) {
    return product.compareTo(other.product);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShowcaseItem &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          neighborhood == other.neighborhood);

  @override
  int get hashCode => Object.hash(product, neighborhood);
}

class ShowcaseItemInfo {
  final DateTime addedAt;
  DateTime? expiresAt;

  ShowcaseItemInfo({
    required this.addedAt,
    required this.expiresAt,
  });
}
