class User implements Comparable<User> {
  final String name;
  final int points;

  const User({
    required this.name,
    required this.points,
  });

  @override
  int compareTo(User other) {
    return other.points.compareTo(points);
  }
}

class MainUser extends User {
  final String number;
  final String email;
  final String token;

  const MainUser({
    required super.name,
    required super.points,
    required this.number,
    required this.email,
    required this.token,
  });
}

class OtherUser extends User {
  const OtherUser({
    required super.name,
    required super.points,
  });

  @override
  String toString() => super.name;
}
