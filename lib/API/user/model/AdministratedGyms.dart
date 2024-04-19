import 'dart:convert';

class AdministratedGym {
  int id;
  String gymName;
  String? imgUrl;

  AdministratedGym(
      {required this.id, required this.gymName, required this.imgUrl});

  factory AdministratedGym.fromJson(Map<String, dynamic> json) {
    return AdministratedGym(
      id: json['id'],
      gymName: json['gymName'],
      imgUrl: json['imgUrl'] == null
          ? "https://st3.depositphotos.com/1765561/14853/i/450/depositphotos_148533399-stock-photo-modern-gym-with-dumbbell-set.jpg"
          : json['imgUrl'],
    );
  }

  static List<AdministratedGym> _parseGyms(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<AdministratedGym>((json) => AdministratedGym.fromJson(json))
        .toList();
  }

  static Future<List<AdministratedGym>> loadAdministratedGyms(
      List<dynamic> jsonResponse) async {
    String jsonString = json.encode(jsonResponse);
    return _parseGyms(jsonString);
  }
}
