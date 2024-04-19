import 'package:fitfinder/API/gym/GymAPI.dart';
import 'package:flutter/material.dart';

import '../../common/AdditionalScreenScaffold.dart';

class AddEquipmentScreen extends StatefulWidget {
  int gymId;

  AddEquipmentScreen(this.gymId);

  @override
  State<AddEquipmentScreen> createState() => _AddEquipmentScreenState();
}

class _AddEquipmentScreenState extends State<AddEquipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _selectedEquipment;
  int? _selectedquantity;
  List<DropdownMenuItem<String>> _equipmentItems = [];
  final TextEditingController imgController = new TextEditingController();

  List<DropdownMenuItem<int>> _quantityList =
      <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
    return DropdownMenuItem<int>(
      value: value,
      child: Text(value.toString()),
    );
  }).toList();

  final Map<String, List<String>> _categoryEquipmentMap = {
    'Cardio': ['Bieżnia', 'Rowerek', 'Wioślarz', 'Schody automatyczne'],
    'Wolne ciężary': [
      'Ławka płaska',
      'Modlitewnik',
      'Skos ujemny',
      'Skos dodatni'
    ],
    'Akcesoria': ['Skakanka', 'Piłka lekarska', 'Gumy treningowe', 'Kettle'],
    'Maszyny': [
      'Wyciskanie nogami leżąc',
      'Wyciskanie nogami siedząc',
      'Wyciąg górny z drążkiem',
      'Maszyna wyciskanie barkami'
    ]
  };

  void _updateEquipmentItems(String? category) {
    setState(() {
      _equipmentItems = _categoryEquipmentMap[category]!
          .map((equipment) => DropdownMenuItem<String>(
                value: equipment,
                child: Text(equipment),
              ))
          .toList();
      _selectedEquipment = null;
    });
  }

  void _updateSelectedEquipment() {
    setState(() {
      _selectedquantity = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdditionalScreenScaffold(
      titleOfPage: "Dodaj wyposażenie",
      body: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropDownTitle("Kategoria"),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Wybierz kategorię sprzętu:",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                        _updateEquipmentItems(newValue);
                      });
                    },
                    items: <String>[
                      'Cardio',
                      'Wolne ciężary',
                      'Akcesoria',
                      'Maszyny'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  DropDownTitle("Sprzęt"),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Wybierz sprzęt:",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedEquipment,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEquipment = newValue;
                        _updateSelectedEquipment();
                      });
                    },
                    items: _equipmentItems.isNotEmpty ? _equipmentItems : null,
                  ),
                  SizedBox(height: 20),
                  DropDownTitle("Ilość"),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Wybierz ilość:",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedquantity,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedquantity = newValue;
                      });
                    },
                    menuMaxHeight: 240,
                    items: _selectedEquipment == null ? null : _quantityList,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropDownTitle(
                    "Link do zdjęcia",
                    subtitle: "opcjonalne",
                  ),
                  TextFormField(
                      controller: imgController,
                      decoration: InputDecoration(
                        labelText: 'URL',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.transparent,
                          fontSize: 0,
                        ),
                      )),
                  SizedBox(height: 20),
                  if (_selectedCategory != null &&
                      _selectedEquipment != null &&
                      _selectedquantity != null)
                    ElevatedButton(
                        onPressed: () => addEquipment(_selectedEquipment!,
                            _selectedquantity!, imgController.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          elevation: 3,
                          padding: EdgeInsets.all(20),
                        ),
                        child: Text(
                          "Dodaj wyposażenie",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white),
                        ))
                ],
              ),
            ),
          )),
    );
  }

  addEquipment(String gymGearName, int quantity, String? imgUrl) async {
    if (_formKey.currentState!.validate()) {
      try {
        await new GymAPI()
            .addEquipment(widget.gymId, gymGearName, quantity, imgUrl);
        Navigator.pop(context);
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Wystąpił problem"),
              content: Text("Nie udało się dodać wyposażenia do siłowni."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}

class DropDownTitle extends StatelessWidget {
  String title;
  String? subtitle;

  DropDownTitle(this.title, {this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if (subtitle != null)
              Text(
                "(${subtitle!})",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontStyle: FontStyle.italic),
              )
          ],
        ));
  }
}
