import 'package:comizy/utils/nickname_generator.dart';

class RankingEntry implements Comparable<RankingEntry> {
  final String userId;
  final int points;
  final String cityName;
  final String neighborhoodName;
  final bool isCurrentUser;

  const RankingEntry({
    required this.userId,
    required this.points,
    required this.cityName,
    required this.neighborhoodName,
    required this.isCurrentUser,
  });

  String get userName =>
      isCurrentUser ? 'Você' : NicknameGenerator.generate(userId);

  @override
  int compareTo(RankingEntry other) => other.points.compareTo(points);
}

class Ranking {
  final List<RankingEntry> entries;

  Ranking({required List<RankingEntry> entries})
      : entries = List<RankingEntry>.from(entries)
          ..sort((a, b) => b.points.compareTo(a.points));

  List<String> get cities {
    final citySet = entries.map((entry) => entry.cityName).toSet();
    final cityList = citySet.toList()..sort();
    return cityList;
  }

  List<String> neighborhoodsFromCity(String city) {
    final neighborhoodSet = entries
        .where((entry) => entry.cityName == city)
        .map((entry) => entry.neighborhoodName)
        .toSet();
    final neighborhoodList = neighborhoodSet.toList()..sort();
    return neighborhoodList;
  }

  List<RankingEntry> filteredEntries({String? city, String? neighborhood}) {
    return entries.where((entry) {
      final cityMatches = city == null || entry.cityName == city;
      final neighborhoodMatches =
          neighborhood == null || entry.neighborhoodName == neighborhood;
      return cityMatches && neighborhoodMatches;
    }).toList();
  }
}
