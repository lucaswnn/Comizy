import 'package:flutter/material.dart';
import 'package:comizy/services/change_notifiers/ranking_notifier.dart';
import 'package:comizy/tads/ranking.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  static const String _allCities = 'Todas';
  static const String _allNeighborhoods = 'Todos';
  static const int _leaderboardSize = 10;

  late final Future<void> _loadFuture;
  String _selectedCity = _allCities;
  String _selectedNeighborhood = _allNeighborhoods;

  @override
  void initState() {
    super.initState();
    _loadFuture = context.read<RankingNotifier>().loadData(forceReload: false);
  }

  List<RankingEntry> _filteredSortedEntries(Ranking ranking) {
    final cityFilter = _selectedCity == _allCities ? null : _selectedCity;
    final neighborhoodFilter = _selectedNeighborhood == _allNeighborhoods
        ? null
        : _selectedNeighborhood;

    final entries = ranking.filteredEntries(
      city: cityFilter,
      neighborhood: neighborhoodFilter,
    );
    entries.sort((a, b) => b.points.compareTo(a.points));
    return entries;
  }

  List<RankingEntry> _buildVisibleEntries(List<RankingEntry> sorted) {
    if (sorted.length <= _leaderboardSize) {
      return sorted;
    }

    final byId = <String, RankingEntry>{};

    void addEntry(RankingEntry entry) {
      byId.putIfAbsent(entry.userId, () => entry);
    }

    for (final entry in sorted.take(3)) {
      addEntry(entry);
    }

    final currentUserIndex = sorted.indexWhere((entry) => entry.isCurrentUser);
    if (currentUserIndex >= 0) {
      addEntry(sorted[currentUserIndex]);

      var left = currentUserIndex - 1;
      var right = currentUserIndex + 1;
      while (byId.length < _leaderboardSize &&
          (left >= 0 || right < sorted.length)) {
        if (left >= 0) {
          addEntry(sorted[left]);
          left--;
        }
        if (byId.length >= _leaderboardSize) {
          break;
        }
        if (right < sorted.length) {
          addEntry(sorted[right]);
          right++;
        }
      }
    }

    for (final entry in sorted) {
      if (byId.length >= _leaderboardSize) {
        break;
      }
      addEntry(entry);
    }

    final visible = byId.values.toList()
      ..sort((a, b) => b.points.compareTo(a.points));
    return visible.take(_leaderboardSize).toList();
  }

  @override
  Widget build(BuildContext context) {
    final rankingNotifier = context.watch<RankingNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking de Pontos'),
      ),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Nao foi possivel carregar o ranking.'),
            );
          }

          final ranking = rankingNotifier.ranking;
          final cityOptions = <String>[_allCities, ...ranking.cities];
          final selectedCity =
              cityOptions.contains(_selectedCity) ? _selectedCity : _allCities;

          final cityNeighborhoods = selectedCity == _allCities
              ? <String>{}
              : ranking.neighborhoodsFromCity(selectedCity).toSet();

          final neighborhoodOptions = <String>[
            _allNeighborhoods,
            ...cityNeighborhoods.toList()..sort(),
          ];
          final selectedNeighborhood =
              neighborhoodOptions.contains(_selectedNeighborhood)
                  ? _selectedNeighborhood
                  : _allNeighborhoods;

          final sortedEntries = _filteredSortedEntries(ranking);
          final visibleEntries = _buildVisibleEntries(sortedEntries);
          final rankById = <String, int>{
            for (var i = 0; i < sortedEntries.length; i++)
              sortedEntries[i].userId: i + 1,
          };

          if (sortedEntries.isEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'Cidade',
                          border: OutlineInputBorder(),
                        ),
                        items: cityOptions
                            .map(
                              (city) => DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCity = value;
                            _selectedNeighborhood = _allNeighborhoods;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedNeighborhood,
                        decoration: const InputDecoration(
                          labelText: 'Bairro',
                          border: OutlineInputBorder(),
                        ),
                        items: neighborhoodOptions
                            .map(
                              (neighborhood) => DropdownMenuItem<String>(
                                value: neighborhood,
                                child: Text(neighborhood),
                              ),
                            )
                            .toList(),
                        onChanged: selectedCity == _allCities
                            ? null
                            : (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedNeighborhood = value;
                                });
                              },
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: Center(
                    child:
                        Text('Nenhum resultado para os filtros selecionados.'),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: selectedCity,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        border: OutlineInputBorder(),
                      ),
                      items: cityOptions
                          .map(
                            (city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCity = value;
                          _selectedNeighborhood = _allNeighborhoods;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedNeighborhood,
                      decoration: const InputDecoration(
                        labelText: 'Bairro',
                        border: OutlineInputBorder(),
                      ),
                      items: neighborhoodOptions
                          .map(
                            (neighborhood) => DropdownMenuItem<String>(
                              value: neighborhood,
                              child: Text(neighborhood),
                            ),
                          )
                          .toList(),
                      onChanged: selectedCity == _allCities
                          ? null
                          : (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedNeighborhood = value;
                              });
                            },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: visibleEntries.length,
                  itemBuilder: (_, i) {
                    final entry = visibleEntries[i];
                    final rank = rankById[entry.userId] ?? (i + 1);
                    final isTop3 = rank <= 3;
                    final iconColor = isTop3 ? Colors.amber.shade700 : null;

                    return ListTile(
                      tileColor: entry.isCurrentUser
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.08)
                          : null,
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('#$rank'),
                          const SizedBox(width: 8),
                          Icon(Icons.emoji_events, color: iconColor),
                        ],
                      ),
                      title: Text(entry.userName),
                      subtitle:
                          Text('${entry.neighborhoodName} - ${entry.cityName}'),
                      trailing: Text('${entry.points} pts'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
