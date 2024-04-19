import 'package:dio/dio.dart';
import 'package:fitfinder/API/gym/model/Gym.dart';
import 'package:fitfinder/general/GymEquipmentMap.dart';

import 'model/GymInformationWithEquipment.dart';

class GymAPI {
  late final Dio _dio;

  static const String _baseUrl = "http://173.212.201.249:8081/gym";
  final timeout = 8;

  GymAPI() {
    _dio = Dio();
  }

  Future<List<Gym>> findGyms(String? city, String? gymName) async {
    final Map<String, dynamic> queryParameters = {
      if (city != null) 'city': city,
      if (gymName != null) 'gymName': gymName,
    };

    Response response = await _dio
        .get(_baseUrl + "/search", queryParameters: queryParameters)
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      List<dynamic> foundedGyms = response.data;
      return Gym.loadGyms(foundedGyms);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<List<GymEquipment>> findEquipmentOfGym(int gymId) async {
    Response response = await _dio
        .get(_baseUrl + "/$gymId/equipment")
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return GymEquipment.loadEquipment(response.data);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<GymInformationWithEquipment> getInformationWithEquipment(
      int gymId) async {
    Response response = await _dio
        .get("http://10.0.2.2:8081/gym" + "/$gymId/getInformationWithEquipment")
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return GymInformationWithEquipment.fromJson(response.data);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<bool> deleteGymEquipment(int gymId, int equipmentId) async {
    Response response = await _dio
        .delete(_baseUrl + "/$gymId/delete/$equipmentId")
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<bool> addEquipment(
      int gymId, String gearName, int quantity, String? imgUrl) async {
    String gymGearName = GymEquipmentMap.nameMap[gearName] ?? "BARBELL";

    var data = {
      'gymGearName': gymGearName,
      'quantity': quantity,
      'imgUrl': imgUrl
    };

    Response response = await _dio
        .post("http://10.0.2.2:8081/gym" + "/$gymId/addEquipment", data: data)
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
