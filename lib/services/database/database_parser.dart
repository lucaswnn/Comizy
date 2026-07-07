import 'package:comizy/tads/app_user.dart';
import 'package:comizy/services/database/database_connection.dart';
import 'package:comizy/tads/help_request.dart';
import 'package:comizy/tads/help_requests.dart';
import 'package:comizy/tads/help_submission.dart';
import 'package:comizy/tads/market.dart';
import 'package:comizy/tads/neighborhood.dart';
import 'package:comizy/tads/offer.dart';
import 'package:comizy/tads/price.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/ranking.dart';
import 'package:comizy/tads/shop.dart';
import 'package:comizy/tads/showcase.dart';

enum SubmitPriceStatus {
  success,
  hold,
  error,
}

class DatabaseParser {
  DatabaseParser._();

  static Future<AppMainUser> getUser(String uid) async {
    final data = await DatabaseConnection.instance.loadUserProfileData();
    return AppMainUser.fromJSON(data);
  }

  static Future<void> addShowcaseSpace({required int newWalletCash}) async {
    await DatabaseConnection.instance.insertShowcaseSlot();
  }

  static Future<void> addShowcaseItem(ShowcaseItem item) async {
    await DatabaseConnection.instance.insertItemInShowcaseSlot(item);
  }

  static Future<void> removeShowcaseItem(ShowcaseItem item) async {
    await DatabaseConnection.instance.removeShowcaseItem(item);
  }

  static Future<Showcase> getShowcase(String uid) async {
    final db = DatabaseConnection.instance;
    final showcaseData = await db.loadUserShowcaseData(uid);
    final showcaseMap = <ShowcaseItem, ShowcaseItemInfo>{};
    int showcaseCount = showcaseData.length;

    for (final showcaseSlot in showcaseData) {
      final Map<String, dynamic>? productData = showcaseSlot['products'];
      final Map<String, dynamic>? neighborhoodData =
          showcaseSlot['neighborhoods'];
      if (productData == null || neighborhoodData == null) {
        continue;
      }

      final showcaseItem = ShowcaseItem.fromJSON(
        productData: productData,
        neighborhoodData: neighborhoodData,
      );
      final showcaseItemInfo = ShowcaseItemInfo.fromJSON(showcaseSlot);
      showcaseMap[showcaseItem] = showcaseItemInfo;
    }

    final userConfigData = await db.loadUserConfigData();
    final int newSpaceCost = userConfigData['new_showcase_slot_cost'];
    final int maxShowcaseSlotDays = userConfigData['max_showcase_slot_days'];

    return Showcase(
      showcaseItems: showcaseMap,
      maxShowcaseItemsCount: showcaseCount,
      newSpaceCost: newSpaceCost,
      maxShowcaseSlotDays: maxShowcaseSlotDays,
    );
  }

  static Future<Market> getMarket() async {
    final db = DatabaseConnection.instance;
    final offersData = await db.loadOffers();
    final market = Market();

    final products = <int, Product>{};
    final shops = <int, Shop>{};

    for (final offerData in offersData) {
      final double price = (offerData['offer_price'] as num).toDouble();
      final String unit = offerData['offer_unit'];
      final lastUpdated = DateTime.parse(offerData['offer_last_updated']);
      final bool needsUpdate = offerData['offer_needs_update'];
      final offerInfo = OfferInfo(
        lastUpdated: lastUpdated,
        needsUpdate: needsUpdate,
        price: Price(value: price, unit: unit),
      );

      final Map<String, dynamic> productData = offerData['products'];
      final productId = productData['product_id'];
      final product = products.putIfAbsent(
        productId,
        () => Product.fromJSON(productData),
      );

      final Map<String, dynamic> shopData = offerData['shops'];
      final shopId = shopData['shop_id'];
      final shop = shops.putIfAbsent(
        shopId,
        () => Shop.fromJSON(shopData),
      );

      final offer = Offer(
        product: product,
        shop: shop,
      );

      market.addOffer(offer, offerInfo);
    }

    return market;
  }

  static Future<int> getMaxSearchDistanceInKm() async {
    final data = await DatabaseConnection.instance.loadUserConfigData();
    return data['max_search_distance_km'];
  }

  static Future<Set<Neighborhood>> getNeighborhoods() async {
    final data = await DatabaseConnection.instance.loadNeighborhoods();
    final neighborhoodSet = <Neighborhood>{};
    for (final neighborhoodData in data) {
      final neighborhood = Neighborhood.fromJSON(neighborhoodData);
      neighborhoodSet.add(neighborhood);
    }

    return neighborhoodSet;
  }

  static Future<HelpRequests> getHelpRequests(
    Set<Neighborhood> neighborhoods,
  ) async {
    final data =
        await DatabaseConnection.instance.loadHelpRequests(neighborhoods);
    final Set<HelpRequest> requests = {};
    for (final helpRequestData in data) {
      final int numberOfOrderes = helpRequestData['total'];
      final Map<String, dynamic> productData = helpRequestData['products'];
      final Map<String, dynamic> neighborhoodData =
          helpRequestData['neighborhoods'];

      final product = Product.fromJSON(productData);
      final neighborhood = Neighborhood.fromJSON(neighborhoodData);

      requests.add(
        HelpRequest(
          product: product,
          neighborhood: neighborhood,
          numberOfOrderers: numberOfOrderes,
        ),
      );
    }

    return HelpRequests(helpRequests: requests);
  }

  static Future<SubmitPriceStatus> submitPriceOffer(
    HelpSubmissionData helpData,
  ) async {
    final data = await DatabaseConnection.instance.submitPriceOffer(helpData);
    final status = (data['status']?.toString() ?? '').toLowerCase();

    switch (status) {
      case 'success':
        return SubmitPriceStatus.success;
      case 'hold':
        return SubmitPriceStatus.hold;
      case 'error':
        return SubmitPriceStatus.error;
      default:
        return SubmitPriceStatus.error;
    }
  }

  static Future<Ranking> getRanking({required String currentUserId}) async {
    final rankingData = await DatabaseConnection.instance.loadRankingData();

    final entries = rankingData.map((data) {
      final String userId = data['user_id'];
      final int points = data['user_ranking_points'];
      final String neighborhoodName = data['neighborhood_name'];
      final String cityName = data['city_name'];

      return RankingEntry(
        userId: userId,
        points: points,
        cityName: cityName,
        neighborhoodName: neighborhoodName,
        isCurrentUser: userId == currentUserId,
      );
    }).toList();

    return Ranking(entries: entries);
  }
}
