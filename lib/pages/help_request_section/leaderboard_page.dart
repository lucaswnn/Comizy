import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardEntry {
  final String id;
  final String name;
  final int points;
  final String neighborhood;
  final bool isCurrentUser;

  const _LeaderboardEntry({
    required this.id,
    required this.name,
    required this.points,
    required this.neighborhood,
    this.isCurrentUser = false,
  });
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  static const String _allNeighborhoods = 'Todos';
  static const int _leaderboardSize = 10;

  static const List<String> _neighborhoods = [
    _allNeighborhoods,
    'Castelo',
    'Jaragua',
    'Colonia do Marcal',
  ];

  static const List<_LeaderboardEntry> _allEntries = [
    _LeaderboardEntry(id: 'u1', name: 'Ana', points: 1500, neighborhood: 'Castelo'),
    _LeaderboardEntry(id: 'u2', name: 'Bruno', points: 1460, neighborhood: 'Castelo'),
    _LeaderboardEntry(id: 'u3', name: 'Caio', points: 1410, neighborhood: 'Castelo'),
    _LeaderboardEntry(id: 'u4', name: 'Duda', points: 1380, neighborhood: 'Castelo'),
    _LeaderboardEntry(id: 'u5', name: 'Elias', points: 1360, neighborhood: 'Castelo'),
    _LeaderboardEntry(id: 'u6', name: 'Fabiana', points: 1335, neighborhood: 'Castelo'),
    _LeaderboardEntry(id: 'u7', name: 'Guilherme', points: 1310, neighborhood: 'Castelo'),
    _LeaderboardEntry(id: 'u8', name: 'Helena', points: 1295, neighborhood: 'Castelo'),
    _LeaderboardEntry(id: 'u9', name: 'Igor', points: 1260, neighborhood: 'Castelo'),
    _LeaderboardEntry(id: 'u10', name: 'Julia', points: 1245, neighborhood: 'Castelo'),
    _LeaderboardEntry(id: 'u11', name: 'Katia', points: 1210, neighborhood: 'Jaragua'),
    _LeaderboardEntry(id: 'u12', name: 'Luan', points: 1190, neighborhood: 'Jaragua'),
    _LeaderboardEntry(id: 'u13', name: 'Marina', points: 1175, neighborhood: 'Jaragua'),
    _LeaderboardEntry(id: 'u14', name: 'Nicolas', points: 1140, neighborhood: 'Jaragua'),
    _LeaderboardEntry(id: 'u15', name: 'Olivia', points: 1120, neighborhood: 'Jaragua'),
    _LeaderboardEntry(id: 'u16', name: 'Paulo', points: 1090, neighborhood: 'Jaragua'),
    _LeaderboardEntry(id: 'u17', name: 'Querencia', points: 1060, neighborhood: 'Jaragua'),
    _LeaderboardEntry(id: 'u18', name: 'Rafaela', points: 1040, neighborhood: 'Jaragua'),
    _LeaderboardEntry(id: 'u19', name: 'Sergio', points: 1025, neighborhood: 'Jaragua'),
    _LeaderboardEntry(
      id: 'current_user',
      name: 'Voce',
      points: 1010,
      neighborhood: 'Jaragua',
      isCurrentUser: true,
    ),
    _LeaderboardEntry(id: 'u21', name: 'Talita', points: 990, neighborhood: 'Colonia do Marcal'),
    _LeaderboardEntry(id: 'u22', name: 'Ubirajara', points: 970, neighborhood: 'Colonia do Marcal'),
    _LeaderboardEntry(id: 'u23', name: 'Vanessa', points: 945, neighborhood: 'Colonia do Marcal'),
    _LeaderboardEntry(id: 'u24', name: 'Willian', points: 920, neighborhood: 'Colonia do Marcal'),
    _LeaderboardEntry(id: 'u25', name: 'Ximena', points: 905, neighborhood: 'Colonia do Marcal'),
    _LeaderboardEntry(id: 'u26', name: 'Yara', points: 890, neighborhood: 'Colonia do Marcal'),
    _LeaderboardEntry(id: 'u27', name: 'Zeca', points: 875, neighborhood: 'Colonia do Marcal'),
  ];

  String _selectedNeighborhood = _allNeighborhoods;

  List<_LeaderboardEntry> _filteredSortedEntries() {
    final entries = _allEntries
        .where(
          (entry) => _selectedNeighborhood == _allNeighborhoods
              ? true
              : entry.neighborhood == _selectedNeighborhood,
        )
        .toList()
      ..sort((a, b) => b.points.compareTo(a.points));
    return entries;
  }

  List<_LeaderboardEntry> _buildVisibleEntries(List<_LeaderboardEntry> sorted) {
    if (sorted.length <= _leaderboardSize) {
      return sorted;
    }

    final byId = <String, _LeaderboardEntry>{};

    void addEntry(_LeaderboardEntry entry) {
      byId.putIfAbsent(entry.id, () => entry);
    }

    for (final entry in sorted.take(3)) {
      addEntry(entry);
    }

    final currentUserIndex = sorted.indexWhere((entry) => entry.isCurrentUser);
    if (currentUserIndex >= 0) {
      addEntry(sorted[currentUserIndex]);

      var left = currentUserIndex - 1;
      var right = currentUserIndex + 1;
      while (byId.length < _leaderboardSize && (left >= 0 || right < sorted.length)) {
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
    final sortedEntries = _filteredSortedEntries();
    final visibleEntries = _buildVisibleEntries(sortedEntries);
    final rankById = <String, int>{
      for (var i = 0; i < sortedEntries.length; i++) sortedEntries[i].id: i + 1,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking de Pontos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedNeighborhood,
              decoration: const InputDecoration(
                labelText: 'Neighborhood',
                border: OutlineInputBorder(),
              ),
              items: _neighborhoods
                  .map(
                    (neighborhood) => DropdownMenuItem<String>(
                      value: neighborhood,
                      child: Text(neighborhood),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedNeighborhood = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: visibleEntries.length,
              itemBuilder: (_, i) {
                final entry = visibleEntries[i];
                final rank = rankById[entry.id] ?? (i + 1);
                final isTop3 = rank <= 3;
                final iconColor = isTop3 ? Colors.amber.shade700 : null;

                return ListTile(
                  tileColor: entry.isCurrentUser
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                      : null,
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('#$rank'),
                      const SizedBox(width: 8),
                      Icon(Icons.emoji_events, color: iconColor),
                    ],
                  ),
                  title: Text(entry.name),
                  subtitle: Text('Neighborhood: ${entry.neighborhood}'),
                  trailing: Text('${entry.points} pts'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
