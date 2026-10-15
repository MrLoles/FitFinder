import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fitfinder/API/gym/model/Contact.dart';
import 'package:fitfinder/API/gym/model/Gym.dart';
import 'package:fitfinder/API/training/model/Workout.dart';
import 'package:fitfinder/general/GymEquipmentMap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/GymInformationWithEquipment.dart';

class GymAPI {
  late final Dio _dio;

  static const String _baseUrl = "http://213.239.130.153:8081/gym";
  // static const String _baseUrl = "http://192.168.0.201:8081/gym";
  final timeout = 8;

  GymAPI() {
    _dio = Dio();
  }

  Future<Options> _authOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      return Options();
    }
    return Options(headers: {"Authorization": "Bearer $token"});
  }

  Future<List<Gym>> findGyms(String? city, String? gymName) async {
    final Map<String, dynamic> queryParameters = {
      if (city != null) 'city': city,
      if (gymName != null) 'gymName': gymName,
    };

    final options = await _authOptions();
    Response response = await _dio
        .get(_baseUrl + "/search",
            queryParameters: queryParameters, options: options)
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      List<dynamic> foundedGyms = response.data;
      return Gym.loadGyms(foundedGyms);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<List<GymEquipment>> findEquipmentOfGym(int gymId) async {
    final options = await _authOptions();
    Response response = await _dio
        .get(_baseUrl + "/$gymId/equipment", options: options)
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return GymEquipment.loadEquipment(response.data);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<GymInformation> getGymInformation(int gymId) async {
    final options = await _authOptions();
    Response response = await _dio
        .get(_baseUrl + "/$gymId/getGymInformation", options: options)
        .timeout(Duration(seconds: timeout));
    if (response.statusCode == 200) {
      return GymInformation.fromJson(response.data);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<bool> deleteGymEquipment(int gymId, int equipmentId) async {
    final options = await _authOptions();
    Response response = await _dio
        .delete(_baseUrl + "/$gymId/delete/$equipmentId", options: options)
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

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.findProxy = (uri) {
        return "PROXY 10.0.2.2:8000;";
      };
      return client;
    };

    final options = await _authOptions();
    Response response = await _dio
        .post(_baseUrl + "/$gymId/addEquipment",
            data: data, options: options)
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<bool> setWorkingHours(
      int gymId,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,
      String sunday) async {
    List<String> data = [
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday
    ];

    final options = await _authOptions();
    Response response = await _dio
        .post(_baseUrl + "/$gymId/workingHours",
            data: json.encode(data), options: options)
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

    final options = await _authOptions();
    Response response = await _dio
        .post(_baseUrl + "/$gymId/contact",
            data: json.encode(data), options: options)
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<bool> setTraining(
      int gymId, String gymName, List<Exercise> exercises) async {
    List<Map<String, dynamic>> exercisesJson =
        exercises.map((e) => e.toJson()).toList();

    var data = {
      'name': gymName,
      'exercises': exercisesJson,
    };

    final options = await _authOptions();
    Response response = await _dio
        .post(_baseUrl + "/$gymId/training",
            data: jsonEncode(data), options: options)
        .timeout(Duration(seconds: timeout));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
