
import 'dart:convert';

// List<Token> accessTokenFromJson(String reponse) => List<Token>.from(json.decode(reponse).map((x) => Token.fromJson(x)));
Token accessTokenFromJson(Map<String, dynamic> response) {
  return Token.fromJson(response);
}


class Token{
  String accessToken;

  Token({required this.accessToken});

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    accessToken: json["accessToken"] == null ? null : json["accessToken"],
  );
}