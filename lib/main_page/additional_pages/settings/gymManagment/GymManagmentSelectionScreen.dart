import 'package:fitfinder/API/user/UserAPI.dart';
import 'package:fitfinder/main_page/additional_pages/settings/gymManagment/GymManagmentScreen.dart';
import 'package:flutter/material.dart';

import '../../../../API/user/model/AdministratedGyms.dart';
import '../../../../general/LoadingSpinner.dart';
import '../../common/AdditionalScreenScaffold.dart';

class GymManagmentSelectionScreen extends StatelessWidget {
  List<AdministratedGym> administratedGyms = [];

  @override
  Widget build(BuildContext context) {
    return AdditionalScreenScaffold(
        titleOfPage: "Wybierz siłownię do edycji",
        body: FutureBuilder(
            future: _loadGyms(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: LoadingSpinnerPage());
              } else if (snapshot.hasError) {
                return Center(child: Text("Ups, coś poszło nie tak :("));
              } else {
                return administratedGyms == 0
                    ? Center(
                        child: Text(
                        "Nie jesteś administratorem żadnej siłowni!",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ))
                    : Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Twoje siłownie:",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: ListView(children: [
                              for (final gym in administratedGyms)
                                _GymTile(administratedGym: gym)
                            ]),
                          ),
                        ],
                      );
              }
            }));
  }

  _loadGyms() async {
    administratedGyms = await new UserAPI().getAdministatedGyms();
  }
}

class _GymTile extends StatelessWidget {
  AdministratedGym administratedGym;

  _GymTile({super.key, required this.administratedGym});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GymManagmentScreen(
                      administratedGym: administratedGym,
                    ))),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: 150,
              width: double.infinity,
              child: Image.network(
                administratedGym.imgUrl!,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(7),
                child: Text(
                  administratedGym.gymName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            )
          ]),
        ),
      ),
      Divider()
    ]);
  }
}
