class User {
  String id;
  String name;
  String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  // Convert User to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  // Convert Map to User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}
