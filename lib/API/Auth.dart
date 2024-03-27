import 'package:dio/dio.dart';
import 'package:fitfinder/API/model/Token.dart';
import 'package:fitfinder/API/model/ValidateToken.dart';
import 'package:flutter/src/widgets/editable_text.dart';

class AuthService {
  static const String _baseUrl = "http://10.0.2.2:8080/user";
  final _dio = Dio();
  final timeout = 5;

  Future<String> login(String username, String password) async {
    try {
      Response response = await _dio
          .post(_baseUrl + "/login",
          data: {'username': username, 'password': password}
      ).timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return accessTokenFromJson(response.data).accessToken.toString();
      }
      else return "";
    } catch (e) {
      return "";
    }
  }

  Future<bool> validateToken(String token) async {
    try {
      Response response = await _dio
          .get(_baseUrl + "/validateToken",
          data: {'token': token}
      ).timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return validateFromJson(response.data).result;
      }
      else return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String login, String email, String password) async {
    try {
      Response response = await _dio
          .post(_baseUrl + "/register",
          data: {'username': login, 'email': email, 'password': password}
      ).timeout(Duration(seconds: timeout));
      //
      // if (response.statusCode == 200) {
      //   return "TODO message or widget";
      // }
      // else return "";
      return true;
    } catch (e) {
      return false;
    }
  }
}