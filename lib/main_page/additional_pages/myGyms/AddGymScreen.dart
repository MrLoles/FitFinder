import 'package:flutter/material.dart';

import '../../../API/gym/Gym.dart';
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

  void search() {
    foundedGyms.clear();
    print(
        'Miasto: ${cityController.text}, Nazwa siłowni: ${nameController.text}');
    Gym gym1 = new Gym(
        gymName: "FitTest",
        address:
            new Address(country: "Poland", city: "Warsaw", street: "ulicowa"),
        openingHours: "8:00-16:00",
        imgUrl:
            "https://img.freepik.com/premium-photo/contemporary-spotless-fitness-gym-center-interiorgenerative-ai_391052-10889.jpg");
    Gym gym2 = new Gym(
        gymName: "MuscleWorkout",
        address: new Address(
            country: "Poland", city: "New York", street: "Main Street"),
        openingHours: "8:00-16:00",
        imgUrl:
            "https://img.freepik.com/free-photo/equipment-gym-modern-interior_74190-3139.jpg");
    Gym gym3 = new Gym(
        gymName: "PowerGym",
        address: new Address(
            country: "Poland", city: "Toronto", street: "Maple Avenue"),
        openingHours: "8:00-16:00",
        imgUrl:
            "https://img.freepik.com/free-photo/modern-fitness-club-interior_1150-22611.jpg");
    foundedGyms.add(gym1);
    foundedGyms.add(gym2);
    foundedGyms.add(gym3);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AdditionalScreenScaffold(
      titleOfPage: "Wyszukaj siłownię",
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
              child: TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'Miasto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 50,
              child: TextField(
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
              child: ListView(
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
                              imageLink: gym.imgUrl,
                              address: gym.address,
                              gymName: gym.gymName,
                            ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
