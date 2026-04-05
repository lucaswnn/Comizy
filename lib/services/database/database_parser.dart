import 'package:comizy/tads/app_user.dart';
import 'package:comizy/services/database/database_connection.dart';
import 'package:comizy/tads/neighborhood.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/product_type.dart';
import 'package:comizy/tads/showcase.dart';
import 'package:latlong2/latlong.dart';

class DatabaseParser {
  DatabaseParser._();

  static Future<AppMainUser> getUser(String uid) async {
    final data = await DatabaseConnection.instance.loadUserProfileData(uid);
    return AppMainUser.fromJSON(data);
  }

  static Future<Showcase> getShowcase(String uid) async {
    final db = DatabaseConnection.instance;
    final showcaseData = await db.loadUserShowcaseData(uid);
    final showcaseMap = <ShowcaseItem, ShowcaseItemInfo>{};
    int showcaseCount = showcaseData.length;
    for (final showcaseSlot in showcaseData) {
      final Map<String, dynamic>? showcaseItemData =
          showcaseSlot['showcase_items'];
      if (showcaseItemData == null) {
        continue;
      }
      final expiresAt = DateTime.tryParse(showcaseSlot['expires_at'] ?? '');
      final addedAt = DateTime.parse(showcaseSlot['inserted_at']);
      final Map<String, dynamic> productData = showcaseItemData['products'];
      final String productName = productData['product_name'];
      final String productDescription =
          productData['product_description'] ?? '';
      final String productAsset = productData['product_asset'] ?? '';
      final Map<String, dynamic> productCategoryData =
          productData['product_categories'];
      final String productCategory =
          productCategoryData['product_category_name'];
      final String productCategoryAsset =
          productCategoryData['product_category_asset'] ?? '';
      final Map<String, dynamic> productSubcategoryData =
          productData['product_subcategories'];
      final String productSubcategory =
          productSubcategoryData['product_subcategory_name'];
      final Map<String, dynamic> neighborhoodData =
          showcaseItemData['neighborhoods'];
      final String neighborhoodName = neighborhoodData['neighborhood_name'];
      final Map<String, dynamic> cityData = neighborhoodData['cities'];
      final String cityName = cityData['city_name'];
      final double neighborhoodLat = neighborhoodData['neighborhood_lat'];
      final double neighborhoodLng = neighborhoodData['neighborhood_lng'];

      final productType = ProductType(
          mainCategory: ProductCategory(productCategory, productCategoryAsset),
          subcategory: ProductSubcategory(productSubcategory));

      final product = Product(
        name: productName,
        description: productDescription,
        productType: productType,
        asset: productAsset,
      );

      final showcaseItem = ShowcaseItem(
        product: product,
        neighborhood: Neighborhood(
            city: cityName,
            name: neighborhoodName,
            latLng: LatLng(neighborhoodLat, neighborhoodLng)),
      );

      final showcaseItemInfo =
          ShowcaseItemInfo(addedAt: addedAt, expiresAt: expiresAt);

      showcaseMap[showcaseItem] = showcaseItemInfo;
    }

    final userConfigData = await db.loadUserConfigData(uid);
    final int newSpaceCost = userConfigData['new_showcase_slot_cost'];
    final int maxShowcaseSlotDays = userConfigData['max_showcase_slot_days'];

    return Showcase(
      showcaseItems: showcaseMap,
      maxShowcaseItemsCount: showcaseCount,
      newSpaceCost: newSpaceCost,
      maxShowcaseSlotDays: maxShowcaseSlotDays,
    );
  }

  static Future<int> getMaxSearchDistanceInKm(String uid) async {
    final data = await DatabaseConnection.instance.loadUserConfigData(uid);
    return data['max_search_distance_km'];
  }

  static Future<Set<Neighborhood>> getNeighborhoods() async {
    final data = await DatabaseConnection.instance.loadNeighborhoods();
    final neighborhoodSet = <Neighborhood>{};
    for(final neighborhoodData in data){
      final Map<String,dynamic> citiesData = neighborhoodData['cities'];
      final String cityName = citiesData['city_name'];
      final String neighborhoodName = neighborhoodData['neighborhood_name'];
      final double lat = neighborhoodData['neighborhood_lat'];
      final double lng = neighborhoodData['neighborhood_lng'];
    
      final neighborhood = Neighborhood(city: cityName, name: neighborhoodName,
      latLng: LatLng(lat, lng),);
      neighborhoodSet.add(neighborhood);
    }
    return neighborhoodSet;
  }
}
