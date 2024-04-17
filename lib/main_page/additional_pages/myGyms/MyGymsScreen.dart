import 'package:fitfinder/API/user/UserAPI.dart';
import 'package:fitfinder/main_page/additional_pages/myGyms/AddGymScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../API/gym/model/Gym.dart';
import '../../../general/LoadingSpinner.dart';
import '../common/AdditionalScreenScaffold.dart';
import 'GymScreen.dart';

class MyGymsScreen extends StatefulWidget {
  @override
  State<MyGymsScreen> createState() => _MyGymsScreenState();
}

class _MyGymsScreenState extends State<MyGymsScreen> {
  List<Gym> foundedGyms = [];

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
                  FutureBuilder(
                      future: initializeMyGyms(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return LoadingSpinnerPage();
                        }
                        else{
                          return Column(
                            children: [
                              for (final gym in foundedGyms) _CardGym(gym: gym)
                            ],
                          );
                        }
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  initializeMyGyms() async {
    foundedGyms = await new UserAPI().getFavouriteGyms();
  }
}

class _CardGym extends StatelessWidget {
  Gym gym;

  _CardGym({required this.gym});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return GymScreen(gym);
          }));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                child: Image.network(
                  gym.imgUrl!,
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                title: Text(
                  gym.gymName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("${gym.address.city}, ul. ${gym.address.street}"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
