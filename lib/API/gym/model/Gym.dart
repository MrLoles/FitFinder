import 'dart:convert';

class Gym {
  final int id;
  final String gymName;
  final Address address;
  final List<String>? openingHours;
  final String? imgUrl;
  final List<GymEquipment>? gymEquipmentList;

  Gym({
    required this.id,
    required this.gymName,
    required this.address,
    this.openingHours,
    this.imgUrl,
    this.gymEquipmentList,
  });

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      id: json['id'],
      gymName: json['gymName'],
      address: Address.fromJson(json['address']),
      openingHours: json['openingHours'] != null
          ? List<String>.from(json['openingHours'])
          : ["8:00-16:00", "8:00-16:00", "8:00-22:00", "8:00-20:00", "8:00-16:00", "8:00-20:00", "8:00-21:00"],
      imgUrl: json['imgUrl'] != null
      ? json['imgUrl'] : "https://img.freepik.com/premium-photo/contemporary-spotless-fitness-gym-center-interiorgenerative-ai_391052-10889.jpg",
    );
  }

  static List<Gym> parseGyms(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<Gym> res = parsed.map<Gym>((json) => Gym.fromJson(json)).toList();
    return parsed.map<Gym>((json) => Gym.fromJson(json)).toList();
  }

  static Future<List<Gym>> loadGyms(List<dynamic> jsonResponse) async {
      String jsonString = json.encode(jsonResponse);
      return parseGyms(jsonString);
  }
}

class Address {
  String country;
  String city;
  String street;

  Address({required this.country, required this.city, required this.street});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      country: json['country'],
      city: json['city'],
      street: json['street'],
    );
  }
}

class GymEquipment {
  final String name;
  final String category;
  final String description;
  final String? imgUrl;
  final int quantity;

  GymEquipment({
    required this.name,
    required this.category,
    required this.description,
    this.imgUrl,
    required this.quantity,
  });

  factory GymEquipment.fromJson(Map<String, dynamic> json) {
    return GymEquipment(
      name: json['name'],
      category: json['category'],
      description: json['description'],
      imgUrl: json['imgUrl'],
      quantity: json['quantity'],
    );
  }

  static List<GymEquipment> parseGymEquipmentList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<GymEquipment>((json) => GymEquipment.fromJson(json)).toList();
  }

  static Future<List<GymEquipment>> loadEquipment(List<dynamic> jsonResponse) async {
    String jsonString = json.encode(jsonResponse);
    return parseGymEquipmentList(jsonString);
  }
}