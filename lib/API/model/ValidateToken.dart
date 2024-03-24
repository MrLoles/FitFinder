ValidateToken validateFromJson(Map<String, dynamic> response) {
  return ValidateToken.fromJson(response);
}


class ValidateToken{
  bool result;

  ValidateToken({required this.result});

  factory ValidateToken.fromJson(Map<String, dynamic> json) => ValidateToken(
    result: json["result"] == null ? null : json["result"],
  );
}