import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitfinder/API/gym/model/Contact.dart';
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

  Future<GymInformation> getGymInformation(
      int gymId) async {
    Response response = await _dio
        // .get(_baseUrl + "/$gymId/getInformationWithEquipment")
        .get("http://10.0.2.2:8081/gym/1/getGymInformation")
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return GymInformation.fromJson(response.data);
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
        .post(_baseUrl + "/$gymId/addEquipment", data: data)
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<bool> setWorkingHours(int gymId, String monday, String tuesday, String wednesday, String thursday, String friday, String saturday, String sunday) async {

    List<String> data = [monday, tuesday, wednesday, thursday, friday, saturday, sunday];

    Response response = await _dio
        // .post(_baseUrl + "/$gymId/workingHours", data: data)\
        .post("http://10.0.2.2:8081/gym/1/workingHours", data: json.encode(data))
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<bool> setContactData(int gymId, Contact contact) async {

    var data = {
      'email': contact.email,
      'phoneNo': contact.phoneNo,
      'instagramLink': contact.instagramLink,
      'facebookLink': contact.facebookLink
    };

    Response response = await _dio
    // .post(_baseUrl + "/$gymId/contact", data: data)\
        .post("http://10.0.2.2:8081/gym/1/contact", data: json.encode(data))
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
