class User {
  final String uid;
  final String username;
  final String email;

  User({required this.uid, required this.username, required this.email});

  // Convert a User object into a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
    };
  }

  // Create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      username: map['username']?? '',
      email: map['email'] ?? '',
    );
  }
}
