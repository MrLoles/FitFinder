import 'Gym.dart';

class GymInformationWithEquipment {
  String gymName;
  Address address;
  List<String>? openingHours;
  List<GymEquipment> gymEquipmentList;

  GymInformationWithEquipment({
    required this.gymName,
    required this.address,
    this.openingHours,
    required this.gymEquipmentList,
  });

  factory GymInformationWithEquipment.fromJson(Map<String, dynamic> json) =>
      GymInformationWithEquipment(
        gymName: json['gymName'],
        address: Address.fromJson(json['address']),
        openingHours: List<String>.from(json['openingHours'] ?? []),
        gymEquipmentList: List<GymEquipment>.from(
            json['gymEquipmentList'].map((x) => GymEquipment.fromJson(x))),
      );
}
