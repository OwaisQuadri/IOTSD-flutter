class User {
  final String name;
  final String phone;
  final bool known;
  final String face;
  final int id;
  final String date;

  User(
      {required this.name,
      required this.phone,
      required this.known,
      required this.face,
      required this.id,
      required this.date});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      phone: json['phone'] as String,
      known: json['known'] as bool,
      face: json['face'] as String,
      id: json['id'] as int,
      date: json['date'] as String,
    );
  }
}
