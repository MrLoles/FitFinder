import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitfinder/API/training/model/Workout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainingAPI{

  static const String _baseUrl = "http://173.212.201.249:8082/training";
  final timeout = 8;

  Future<List<dynamic>> getAllTrainingDays() async {
    final _dio = Dio();

    WidgetsFlutterBinding.ensureInitialized();
    Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await futurePrefs;
    String token = prefs.getString('token')!;

    Options options = Options(headers: {"token":token});

    try {
      Response response = await _dio.get(_baseUrl + "/getAll", options: options).timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        List<dynamic> trainingDays = response.data;
        return trainingDays;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch training days: $e');
    }
  }

  Future<String> deleteTrainingDay(int dayOfWeekNumber) async {
    final _dio = Dio();

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;

    Options options = Options(headers: {"token":token});

    try {
      Response response = await _dio.get(_baseUrl + "/delete/$dayOfWeekNumber", options: options).timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch training days: $e');
    }
  }

  Future<String> getSpecificTraining(int dayOfWeekNumber) async {
    final _dio = Dio();

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;

    Options options = Options(headers: {"token":token});

    try {
      Response response = await _dio.get(_baseUrl + "/get/$dayOfWeekNumber", options: options).timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch training days: $e');
    }
  }

  Future<String> addTrainingDay(Workout workout) async {
    final _dio = Dio();

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;

    Options options = Options(headers: {"token":token, "Content-Type": "application/json"});

    try {
      Response response = await _dio.post(_baseUrl + "/add", options: options, data: jsonEncode(workout.toJson())).timeout(Duration(seconds: timeout));

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add training day: $e');
    }
  }

}