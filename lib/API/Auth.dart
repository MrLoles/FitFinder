import 'package:dio/dio.dart';
import 'package:fitfinder/API/model/Token.dart';
import 'package:fitfinder/API/model/ValidateToken.dart';

class AuthService {
  static const String _baseUrl = "http://173.212.201.249:8080/user";
  final timeout = 5;

  Future<String> login(String usernameOrEmail, String password) async {
    final _dio = Dio();
    var data;

    if(usernameOrEmail.contains("@")){
      data = {'email': usernameOrEmail, 'password': password};
    }else{
      data = {'username': usernameOrEmail, 'password': password};
    }

    try {
      Response response = await _dio
          .post(_baseUrl + "/login",
          data: data
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
    final _dio = Dio();

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

  Future<int> register(String login, String email, String password) async {
    final _dio = Dio();
    _dio.options.validateStatus = (status) {
      return status! >= 200 && status <= 400;
    };

    try {
      Response response = await _dio.post(
        _baseUrl + "/register",
        data: {'username': login, 'email': email, 'password': password},
      ).timeout(Duration(seconds: timeout));

      return response.statusCode ?? 500;
    } catch (e) {
      return 500;
    }
  }

  Future<int> forgotPassword(String email) async {
    final _dio = Dio();
    _dio.options.validateStatus = (status) {
      return status! >= 200 && status <= 499;
    };

    try {
      Response response = await _dio.post(
        _baseUrl + "/resetPasswordChallenge",
        data: {'email': email},
      ).timeout(Duration(seconds: timeout));

      return response.statusCode ?? 500;
    } catch (e) {
      return 500;
    }
  }
}