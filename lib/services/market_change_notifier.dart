import 'package:comizy/tads/market.dart';
import 'package:flutter/material.dart';
import 'package:comizy/utils/mvp_database.dart';

class MarketChangeNotifier extends ChangeNotifier {
  final Market _market = Market.withOffers(offers:mvpOffers);
  Market get market => _market;
}
