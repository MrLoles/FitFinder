import 'package:fitfinder/API/gym/model/Gym.dart';
import 'package:fitfinder/API/training/TrainingAPI.dart';
import 'package:fitfinder/API/user/UserAPI.dart';
import 'package:fitfinder/main_page/additional_pages/contact/ContactScreen.dart';
import 'package:fitfinder/main_page/additional_pages/myGyms/GymScreen.dart';
import 'package:fitfinder/main_page/additional_pages/myGyms/MyGymsScreen.dart';
import 'package:fitfinder/main_page/additional_pages/myWorkout/MyWorkout.dart';
import 'package:fitfinder/main_page/additional_pages/settings/SettingsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/training/model/Workout.dart';
import '../API/user/model/UserDetails.dart';
import '../general/Calendar.dart';
import '../general/LoadingSpinner.dart';
import '../introduction/StartPage.dart';
import 'additional_pages/common/SingleWidgets.dart';

class MainScreen extends StatefulWidget {
  String name = "user";
  String email = "placeholder@email.com";

  @override
  State<MainScreen> createState() => _MainScreenState();

  static _MainScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_MainScreenState>()!;
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ekran główny"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      drawer: CustomSidebar(),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    "Twoje siłownie:",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                PageViewBox(),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Twój dzisiejszy plan:",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _CardTraining(),
                      SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   "Placeholder",
                      //   style: Theme.of(context).textTheme.headlineSmall,
                      // ),
                      // Card(
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           color: Colors.grey[200],
                      //           borderRadius: BorderRadius.circular(10),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.grey.withOpacity(0.1),
                      //               spreadRadius: 3,
                      //               blurRadius: 7,
                      //               offset: Offset(0, 3),
                      //             ),
                      //           ],
                      //         ),
                      //         child: ListTile(
                      //           title: Text("Tu coś będzie"),
                      //           subtitle: Text("Może dostępni trenerzy"),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class PageViewBox extends StatelessWidget {
  List<Gym> favouriteGyms = [];

  PageViewBox({
    super.key,
  });

  final PageController _pageController = PageController(
    viewportFraction: 0.90,
  );

  initializeFavouriteGyms(BuildContext context) async {
    List<Gym> allFavouriteGyms = await new UserAPI().getFavouriteGyms();
    UserDetails userDetails = await new UserAPI().getUserDetails();
    if (allFavouriteGyms.length == 0) {
      favouriteGyms = [];
    } else if (allFavouriteGyms.length <= 3) {
      favouriteGyms = allFavouriteGyms;
    } else
      favouriteGyms = allFavouriteGyms.sublist(0, 3);
    MainScreen.of(context).widget.name = userDetails.username;
    MainScreen.of(context).widget.email = userDetails.email;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: FutureBuilder(
            future: initializeFavouriteGyms(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: LoadingSpinnerPage());
              } else if (snapshot.hasError) {
                return Center(child: Text("Ups, coś poszło nie tak :("));
              } else {
                return favouriteGyms.length == 0
                    ? Center(
                        child: Align(
                          child: Text(
                            "Twoja lista ulubionych siłowni jest pusta!\n Dodaj je poprzez menu boczne!",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: favouriteGyms.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () => {
                                    Navigator.push(context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return GymScreen(favouriteGyms[index]);
                                    }))
                                  },
                              child: GymCard(
                                gym: favouriteGyms[index],
                              ));
                        },
                      );
              }
            }));
  }
}

class _CardTraining extends StatefulWidget {
  Workout? workout;

  _CardTraining({super.key});

  @override
  State<_CardTraining> createState() => _CardTrainingState();
}

class _CardTrainingState extends State<_CardTraining> {
  bool isTrainingCompleted = false;
  String trainingTime = "2:00h";
  Workout? workout;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: CalendarWeek()),
          FutureBuilder(
              future: fetchTrainingData(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: LoadingSpinnerDialog());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Ups, coś poszło nie tak :("));
                } else
                  return workout == null
                      ? Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "Na dziś nie masz zaplanowanego żadnego treningu",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ))
                      : ListTile(
                          title: Text(
                            workout!.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: GestureDetector(
                            onTap: () => {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return MyWorkout();
                              }))
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Szacowany czas treningu: " + trainingTime),
                                Text('Kliknij aby przejść do szczegółów'),
                              ],
                            ),
                          ),
                          // trailing: Checkbox(
                          //   value: isTrainingCompleted,
                          //   onChanged: (newValue) {
                          //     setState(() {
                          //       isTrainingCompleted = newValue!;
                          //     });
                          //   },
                          // ),
                        );
              }),
        ],
      ),
    );
  }

  fetchTrainingData(BuildContext context) async {
    workout =
        await new TrainingAPI().getSpecificTraining(DateTime.now().weekday);
  }
}

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
            child: Container(
      child: Column(
        children: [
          HeaderDrawerItem(),
          const Divider(),
          MenuItems(),
        ],
      ),
    )));
  }
}

class HeaderDrawerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
          child: Column(
            children: [
              CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(
                      'https://cdn3.iconfinder.com/data/icons/design-n-code/100/272127c4-8d19-4bd3-bd22-2b75ce94ccb4-512.png')),
              _UserDetails(),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserDetails extends StatelessWidget {
  const _UserDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).primaryTextTheme;

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(
            MainScreen.of(context).widget.name,
            style: theme.bodyLarge,
          ),
          Text(
            MainScreen.of(context).widget.email,
            style: theme.bodyMedium,
          )
        ],
      ),
    );
  }
}

class MenuItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home_filled),
          title: const Text("Ekran główny"),
          onTap: () => {
            Navigator.push(context,
                new MaterialPageRoute(builder: (BuildContext context) {
              return MainScreen();
            }))
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month),
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyWorkout()))
          },
          title: const Text("Mój plan"),
        ),
        ListTile(
          leading: const Icon(Icons.fitness_center),
          title: const Text("Moje siłownie"),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyGymsScreen())),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Ustawienia"),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsScreen())),
        ),
        ListTile(
          leading: const Icon(Icons.message),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ContactScreen())),
          title: const Text("Kontakt"),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (BuildContext context) {
              _clearSharedPrefs();
              return StartPage();
            }));
          },
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Wyloguj"),
          ),
        )
      ],
    );
  }

  void _clearSharedPrefs() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
  }
}
