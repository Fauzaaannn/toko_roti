class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String accessToken;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.accessToken,
  });

  // Factory constructor untuk membuat instance User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      accessToken: json['accessToken'],
    );
  }
}