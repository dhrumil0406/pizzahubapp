class User {
  final int userid;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final BigInt phone;

  User({
    required this.userid,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userid: int.tryParse(json['userid']?.toString() ?? '') ?? 0,
      username: json['username']?.toString() ?? '',
      firstname: json['firstname']?.toString() ?? '',
      lastname: json['lastname']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: BigInt.tryParse(json['phone']?.toString() ?? '0') ?? BigInt.zero,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone.toString(),
    };
  }
}
