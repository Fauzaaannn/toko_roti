// lib/user_model.dart

class User {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
  });
}