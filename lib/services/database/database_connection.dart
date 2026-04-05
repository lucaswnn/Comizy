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
    final data = await _dbInstance
        .from('profiles')
        .update({
          'user_name': name,
          'user_number': number,
        })
        .eq('user_id', uid)
        .select();
    print('update new account data:\n$data');
  }

  Future<Map<String, dynamic>> loadUserProfileData(String uid) async {
    final data = await _dbInstance.from('profiles').select().single();
    print('load user profile data:\n$data');
    return data;
  }

  Future<Map<String, dynamic>> loadUserConfigData(String uid) async {
    final data = await _dbInstance.from('user_config').select().single();
    print('load user config:\n$data');
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
          neighborhood_name,
          cities(city_name),
          neighborhood_lat,
          neighborhood_lng
        )
      )
      ''',
    ).eq('user_id', uid);
    print('load user showcase data:\n$data');
    return data;
  }

  Future<List<Map<String,dynamic>>> loadNeighborhoods() async{
    final data = await _dbInstance.from('neighborhoods').select(
      '''
      neighborhood_name,
      neighborhood_lat,
      neighborhood_lng,
      cities
      (
        city_name
      )
      ''',
    );
    print('load neighborhoods data:\n$data');
    return data;
  }
}
