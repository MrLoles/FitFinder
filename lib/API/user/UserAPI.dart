import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gym/model/Gym.dart';
import 'model/UserDetails.dart';

class UserAPI {
  late final Dio _dio;

  static const String _baseUrl = "http://173.212.201.249:8083/user";
  final timeout = 8;

  UserAPI() {
    this._dio = new Dio();
  }

  Future<bool> addGymToFavourites(int gymId) async {
    Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await futurePrefs;
    String token = prefs.getString('token')!;

    final Map<String, dynamic> data = {
      'id': gymId,
    };

    Options options = Options(headers: {"token": token});

    try {
      Response response = await _dio
          .post(_baseUrl + "/addGymToFavourites",
              data: data, options: options)
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return response.data as bool;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add to favourites: $e');
    }
  }

  Future<Response<dynamic>> checkFavourites(int gymId) async {
    Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await futurePrefs;
    String token = prefs.getString('token')!;

    Options options = Options(headers: {"token": token});

    try {
      Response response = await _dio
          .get(_baseUrl + "/favourites/$gymId",
          options: options)
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add to favourites: $e');
    }
  }

  Future<List<Gym>> getFavouriteGyms() async{
    Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await futurePrefs;
    String token = prefs.getString('token')!;

    Options options = Options(headers: {"token": token});

    Response response = await _dio.get(_baseUrl + "/favourites", options: options).timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      List<dynamic> foundedGyms = response.data;
      if(foundedGyms.isEmpty){
        return [];
      }
      return Gym.loadGyms(foundedGyms);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<UserDetails> getUserDetails() async{
    Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await futurePrefs;
    String token = prefs.getString('token')!;

    Options options = Options(headers: {"token": token});

    Response response = await _dio.get(_baseUrl + "/getUserInfo", options: options).timeout(Duration(seconds: timeout));


    if (response.statusCode == 200) {
      print(response.data);
      return UserDetails.fromJson(response.data);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
