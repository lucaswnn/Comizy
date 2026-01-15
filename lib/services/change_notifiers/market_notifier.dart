import 'package:comizy/tads/market.dart';
import 'package:flutter/material.dart';

class MarketNotifier with ChangeNotifier {
  final Market _market = Market();

  Market get market => _market;
}
