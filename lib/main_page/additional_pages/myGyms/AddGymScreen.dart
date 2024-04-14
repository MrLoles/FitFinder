import 'package:fitfinder/API/gym/GymAPI.dart';
import 'package:flutter/material.dart';

import '../../../API/gym/model/Gym.dart';
import '../../../general/LoadingSpinner.dart';
import '../../../general/NavigationAnimation.dart';
import '../common/AdditionalScreenScaffold.dart';
import '../common/SingleWidgets.dart';
import 'GymScreen.dart';

class AddGym extends StatefulWidget {
  @override
  State<AddGym> createState() => _AddGymState();
}

class _AddGymState extends State<AddGym> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  List<Gym> foundedGyms = [];
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void search() async {
    if(_formKey.currentState!.validate()) {
      foundedGyms.clear();
      setState(() {
        _isLoading = true;
      });
        foundedGyms = await new GymAPI().findGyms(cityController.text, nameController.text);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdditionalScreenScaffold(
      titleOfPage: "Wyszukaj siłownię",
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                "Wyszukaj siłownię za pomocą miasta lub nazwy siłowni",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
          Container(
            width: double.infinity,
            height: 50,
            child: TextFormField(
              validator: (value) => cityValidator(value),
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Miasto',
                labelStyle: TextStyle(
                  color: Colors.black
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorStyle: TextStyle(
                  color: Colors.transparent,
                  fontSize: 0,
                ),
              ))),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nazwa',
                    hintText: 'Wpisz nazwę szukanej siłowni',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: search,
                child: Text('Wyszukaj'),
              ),
              Divider(),
              Expanded(
                child: _isLoading? LoadingSpinnerPage() : ListView(
                  children: [
                    for (final gym in foundedGyms)
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                              onTap: () => {
                                    Navigator.push(
                                        context,
                                        NavigationAnimation
                                            .changeScreenWithAnimationRTL(
                                                GymScreen(gym)))
                                  },
                              child: GymCard(
                                imageLink: gym.imgUrl ?? "https://img.freepik.com/premium-photo/contemporary-spotless-fitness-gym-center-interiorgenerative-ai_391052-10889.jpg",
                                address: gym.address,
                                gymName: gym.gymName,
                              ))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  cityValidator(value) {
      if (value == null || value.isEmpty) {
        return "null";
      }
      return null;
  }
}
