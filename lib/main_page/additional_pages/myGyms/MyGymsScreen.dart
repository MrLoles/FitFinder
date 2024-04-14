import 'package:fitfinder/main_page/additional_pages/myGyms/AddGymScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../API/gym/Gym.dart';
import '../common/AdditionalScreenScaffold.dart';

class MyGymsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdditionalScreenScaffoldWithFloatingButton(
      titleOfPage: "Moje siłownie",
      floatingButtonAction: () => {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return AddGym();
        }))
      },
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: Text("Twoje zapisane siłownie:",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _CardGym(
                    gymName: "Gorilla gym",
                    gymAdress: new Address(
                        country: "Polska",
                        city: "Siedlce",
                        street: "Partyzantów 14"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CardGym extends StatelessWidget {
  String gymName;
  Address gymAdress;

  _CardGym({required this.gymName, required this.gymAdress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context,
        //   new MaterialPageRoute(builder: (BuildContext context) {
        //     return GymScreen(gym);
        //   }));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzSOS8c7I9-rW1TjkNXXyc4virP40d2rsMLahbc98dqA&s",
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              title: Text(
                gymName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${gymAdress.city}, ul. ${gymAdress.street}"),
            )
          ],
        ),
      ),
    );
  }
}
