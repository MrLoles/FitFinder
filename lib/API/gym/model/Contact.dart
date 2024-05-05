import 'dart:convert';

class Contact {
  String email;
  String phoneNo;
  String instagramLink;
  String facebookLink;

  Contact({
    required this.email,
    required this.phoneNo,
    required this.instagramLink,
    required this.facebookLink,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      email: json['email'],
      phoneNo: json['phoneNo'],
      instagramLink: json['instagramLink'],
      facebookLink: json['facebookLink'],
    );
  }
}