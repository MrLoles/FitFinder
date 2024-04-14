class Address{
  String country;
  String city;
  String street;

  Address({required this.country,required this.city,required this.street});
}

class Gym {
  String gymName;
  Address address;
  String openingHours;
  String imgUrl;

  Gym({required this.gymName,required this.address,required this.openingHours,required this.imgUrl});
}

class GymGear{
  String name;
  String category;
  String description;
  String imgUrl;
  int quantity;

  GymGear({required this.name,required this.category,required this.description,required this.quantity, required this.imgUrl});
}