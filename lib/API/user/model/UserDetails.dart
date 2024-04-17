class UserDetails {
  String email;
  String username;

  UserDetails({required this.email, required this.username});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      email: json['email'],
      username: json['username'],
    );
  }
}