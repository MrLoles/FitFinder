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
  bool failedRequest = false;

  void search() async {
    if(_formKey.currentState!.validate()) {
      failedRequest = false;
      foundedGyms.clear();
      setState(() {
        _isLoading = true;
      });
      try{
        foundedGyms = await new GymAPI().findGyms(cityController.text, nameController.text);
      } catch (e){
        failedRequest = true;
      }finally{
        setState(() {
          _isLoading = false;
        });
      }
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
                    if(failedRequest) Text("Wystąpił problem z połączeniem internetowym")
                    else for (final gym in foundedGyms)
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
                                gym: gym
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
