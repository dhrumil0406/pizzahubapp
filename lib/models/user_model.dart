class User {
  final int userid;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String phoneno;
  final String usertype;
  final DateTime updatedAt;
  final String? password; // 🔹 add password (nullable)

  User({
    required this.userid,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phoneno,
    required this.usertype,
    required this.updatedAt,
    this.password, // 🔹 optional
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userid: int.tryParse(json['userid']?.toString() ?? '') ?? 0,
      username: json['username']?.toString() ?? '',
      firstname: json['firstname']?.toString() ?? '',
      lastname: json['lastname']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneno: json['phoneno']?.toString() ?? '',
      usertype: json['usertype']?.toString() ?? '',
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime(1970, 1, 1),
      password: json['password']?.toString(), // 🔹 handle if API returns it
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phoneno': phoneno,
      'usertype': usertype,
      'updated_at': updatedAt.toIso8601String(),
      if (password != null && password!.isNotEmpty)
        'password': password, // 🔹 only send if provided
    };
  }
}
