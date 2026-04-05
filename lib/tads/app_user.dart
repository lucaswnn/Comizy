import 'package:comizy/tads/wallet.dart';

class AppUser implements Comparable<AppUser> {
  final String name;
  final int points;

  const AppUser({
    required this.name,
    required this.points,
  });

  @override
  int compareTo(AppUser other) {
    return other.points.compareTo(points);
  }
}

class AppMainUser extends AppUser {
  final String number;
  final Wallet wallet;

  const AppMainUser({
    required super.name,
    required super.points,
    required this.number,
    required this.wallet,
  });

  factory AppMainUser.fromJSON(Map<String, dynamic> json) {
    return AppMainUser(
      name: json['user_name'],
      points: 0,
      number: json['user_number'],
      wallet: Wallet(json['user_wallet']),
    );
  }
}

class AppOtherUser extends AppUser {
  const AppOtherUser({
    required super.name,
    required super.points,
  });

  @override
  String toString() => super.name;
}
