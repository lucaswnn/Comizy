import 'package:comizy/tads/neighborhood.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseConnection {
  DatabaseConnection._();
  static final DatabaseConnection instance = DatabaseConnection._();

  static final _dbInstance = Supabase.instance.client;

  Future<void> updateNewAccount({
    required String uid,
    required String name,
    required String number,
  }) async {
    await _dbInstance
        .from('profiles')
        .update({
          'user_name': name,
          'user_number': number,
        })
        .eq('user_id', uid)
        .select();
  }

  Future<Map<String, dynamic>> loadUserProfileData(String uid) async {
    final data = await _dbInstance.from('profiles').select().single();

    return data;
  }

  Future<Map<String, dynamic>> loadUserConfigData(String uid) async {
    final data = await _dbInstance.from('user_config').select().single();

    return data;
  }

  Future<List<Map<String, dynamic>>> loadUserShowcaseData(String uid) async {
    final data = await _dbInstance.from('showcase').select(
      '''
      expires_at,
      inserted_at,
      showcase_items
      (
        products
        (
          product_id,
          product_name,
          product_description,
          product_asset,
          product_categories
          (
            product_category_name,
            product_category_asset
          ),
          product_subcategories(product_subcategory_name)
        ),
        neighborhoods
        (
          neighborhood_id,
          neighborhood_name,
          cities(city_name),
          neighborhood_lat,
          neighborhood_lng
        )
      )
      ''',
    ).eq('user_id', uid);

    return data;
  }

  Future<List<Map<String, dynamic>>> loadNeighborhoods() async {
    final data = await _dbInstance.from('neighborhoods').select(
      '''
      neighborhood_id,
      neighborhood_name,
      neighborhood_lat,
      neighborhood_lng,
      cities
      (
        city_name
      )
      ''',
    );

    return data;
  }

  Future<List<Map<String, dynamic>>> loadHelpRequests(
      Set<Neighborhood> neighborhoods) async {
    final neighborhoodIds = neighborhoods.map((e) => e.id).toList();
    final data = await _dbInstance.from('help_requests').select('''
          products
          (
            product_id,
            product_name,
            product_description,
            product_asset,
            product_categories
            (
              product_category_name,
              product_category_asset
            ),
            product_subcategories(product_subcategory_name)
          ),
          neighborhoods
          (
            neighborhood_id,
            neighborhood_name,
            neighborhood_lat,
            neighborhood_lng,
            cities
            (
              city_name
            )
          ),
          total
          ''').inFilter('neighborhood_id', neighborhoodIds);

    return data;
  }

  Future<List<Map<String, dynamic>>> loadOffers() async {
    final data = await _dbInstance.from('offers_with_needs_change_flag').select(
      '''
      shops
      (
        shop_id,
        shop_name,
        shop_lat,
        shop_lng,
        neighborhoods
        (
          neighborhood_id,
          neighborhood_name,
          neighborhood_lat,
          neighborhood_lng,
          cities
          (
            city_name
          )
        )
      ),
      products
      (
        product_id,
        product_name,
        product_description,
        product_asset,
        product_categories
        (
          product_category_name,
          product_category_asset
        ),
        product_subcategories(product_subcategory_name)
      ),
      offer_price,
      offer_last_updated,
      offer_unit,
      offer_needs_update
      ''',
    );

    return data;
  }
}
