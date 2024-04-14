import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitfinder/API/gym/model/Gym.dart';

class GymAPI{
  late final Dio _dio;

  static const String _baseUrl = "http://10.0.2.2:8081/gym";
  final timeout = 8;

  GymAPI(){
    _dio = Dio();
  }

  Future<List<Gym>> findGyms(String? city, String? gymName) async{
    final Map<String, dynamic> queryParameters = {
      if (city != null) 'city': city,
      if (gymName != null) 'gymName': gymName,
    };

      Response response = await _dio.get(_baseUrl + "/search", queryParameters: queryParameters).timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      List<dynamic> foundedGyms = response.data;
      return Gym.loadGyms(foundedGyms);
    } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
  }

  Future<List<GymEquipment>> findEquipmentOfGym(String id) async{

    Response response = await _dio.get(_baseUrl + "/$id/equipment").timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return GymEquipment.loadEquipment(response.data);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}