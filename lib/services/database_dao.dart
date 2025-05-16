import 'package:comizy/services/database_parser.dart';
import 'package:comizy/tads/product.dart';
import 'package:comizy/tads/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class DatabaseDAO {
  const DatabaseDAO._();

  static const String projectUrl = 'https://zcwurmayldfgrexrimhe.supabase.co';
  static const String projectApiAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpjd3VybWF5bGRmZ3JleHJpbWhlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDczNDQwNDIsImV4cCI6MjA2MjkyMDA0Mn0.vsJ_2BxPMnd9y9ygl8gOsXswXgQGoW2i37PY_ojv6wk';
  static const String tableName = 'orcamentos';
  static const String userColumnName = 'nome_usuario';
  static const String userNumberColumnName = 'numero_usuario';
  static const String cartDataColumnName = 'lista_produtos';

  static Future<void> initialize() async {
    await supabase.Supabase.initialize(
      url: projectUrl,
      anonKey: projectApiAnonKey,
    );
  }

  static Future<void> sendCartData(
      User user, Map<Product, int> products,) async {
    final client = supabase.Supabase.instance.client;
    final jsonData = DatabaseParser.cartToJson(products);

    await client.from(tableName).insert(
      <String, dynamic>{
        userColumnName: user.name,
        userNumberColumnName: user.number,
        cartDataColumnName: jsonData,
      },
    );
  }
}
