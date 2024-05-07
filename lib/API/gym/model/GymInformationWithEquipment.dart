import '../../training/model/Workout.dart';
import 'Contact.dart';
import 'Gym.dart';

class GymInformation {
  String gymName;
  Address address;
  List<String>? openingHours;
  List<GymEquipment> gymEquipmentList;
  Contact? contact;
  Workout? workout;

  GymInformation({
    required this.gymName,
    required this.address,
    this.openingHours,
    required this.gymEquipmentList,
    this.contact,
    this.workout
  });

  factory GymInformation.fromJson(Map<String, dynamic> json) =>
      GymInformation(
        gymName: json['gymName'],
        address: Address.fromJson(json['address']),
        openingHours: List<String>.from(json['openingHours'] ?? []),
        gymEquipmentList: List<GymEquipment>.from(
            json['gymEquipmentList'].map((x) => GymEquipment.fromJson(x))),
        contact: Contact.fromJson(json['contact'] ?? null),
        workout: Workout.fromJson(json['training'] ?? null)
      );

  factory GymInformation.defaultBuilder() =>
      GymInformation(gymName: "temp", address: Address(country: "test",city: "test", street: "test"), gymEquipmentList: [GymEquipment(id: 1, name: "name", category: "category", description: "description", quantity: 1)]);
}
