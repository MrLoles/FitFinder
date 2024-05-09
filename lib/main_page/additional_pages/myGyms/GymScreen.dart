import 'package:fitfinder/API/gym/GymAPI.dart';
import 'package:fitfinder/API/gym/model/Contact.dart';
import 'package:fitfinder/API/gym/model/GymInformationWithEquipment.dart';
import 'package:fitfinder/API/user/UserAPI.dart';
import 'package:flutter/material.dart';

import '../../../API/gym/model/Gym.dart';
import '../../../API/training/model/Workout.dart';
import '../../../general/LoadingSpinner.dart';
import '../common/AdditionalScreenScaffold.dart';

class GymScreen extends StatefulWidget {
  Gym gym;
  late UserAPI userAPI;

  GymScreen(this.gym) {
    userAPI = new UserAPI();
  }

  @override
  State<GymScreen> createState() => _GymScreenState();
}

class _GymScreenState extends State<GymScreen>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  late TabController _tabController;
  late GymInformation gymInformation;

  @override
  void initState() {
    fetchFavouriteStatus();
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.gym.gymName,
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : null,
            ),
            onPressed: addToFavourites,
          ),
        ],
      ),
      body: FutureBuilder(
          future: _getGymInformations(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: LoadingSpinnerPage());
            } else if (snapshot.hasError) {
              return Center(child: Text("Ups, coś poszło nie tak :("));
            } else {
              return TabBarView(
                controller: _tabController,
                children: [
                  _GeneralInfoTab(
                    workingHours: gymInformation.openingHours,
                    contact: gymInformation.contact,
                  ),
                  _GymEquipmentTab(gym: widget.gym),
                  _TrainingTab(
                      workout:
                          gymInformation.workout ?? Workout.defaultBuilder()),
                ],
              );
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Informacje',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Wyposażenie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            label: 'Trening',
          ),
        ],
        currentIndex: _tabController.index,
        onTap: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
      ),
    );
  }

  addToFavourites() async {
    showDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return LoadingSpinnerDialog();
      },
      context: context,
    );
    try {
      await widget.userAPI.addGymToFavourites(widget.gym.id);
      setState(() {
        fetchFavouriteStatus();
      });
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> fetchFavouriteStatus() async {
    try {
      var response = await widget.userAPI.checkFavourites(widget.gym.id);
      if (response.statusCode == 200) {
        setState(() {
          isLiked = response.data;
        });
      } else {
        throw Exception('Failed to load favourite status');
      }
    } catch (e) {}
  }

  _getGymInformations() async {
    gymInformation = await new GymAPI().getGymInformation(widget.gym.id);
  }
}

class _TrainingTab extends StatelessWidget {
  _TrainingTab({required this.workout});

  Workout? workout;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.only(top: 20),
        child: Text("Trening wprowadzający:",
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Container(
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(10),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: () {
                    if (workout == null) {
                      return Text("Ups, coś poszło nie tak");
                    } else if (workout!.exercises.length >= 1) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: workout!.exercises.map((exercise) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${exercise.name}'.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Serie: ${exercise.sets}'),
                              Text(
                                  'Powtórzenia: ${exercise.reps.toString().replaceAll("[", "").replaceAll("]", "")}'),
                              Text('Obciążenie: ${exercise.weights}'),
                              Divider(),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          );
                        }).toList(),
                      );
                    } else if (workout!.exercises.length == 0) {
                      return Text("Brak treningu wprowadzającego!");
                    }
                  }()),
            ),
          ))
    ]);
  }
}

class _GymEquipmentTab extends StatefulWidget {
  Gym gym;

  _GymEquipmentTab({super.key, required this.gym});

  @override
  State<_GymEquipmentTab> createState() => _GymEquipmentTabState();
}

class _GymEquipmentTabState extends State<_GymEquipmentTab> {
  final List<GymEquipment> gymCardioList = [];

  final List<GymEquipment> gymFreeWeightsList = [];

  final List<GymEquipment> gymMachinesList = [];

  final List<GymEquipment> gymAccessoriesList = [];

  Future<void> initializelists() async {
    gymCardioList.clear();
    gymFreeWeightsList.clear();
    gymMachinesList.clear();
    gymAccessoriesList.clear();
    List<GymEquipment> gymEquipmentList =
        await new GymAPI().findEquipmentOfGym(widget.gym.id);
    gymEquipmentList.forEach((equipment) {
      if (equipment.category == "Cardio")
        gymCardioList.add(equipment);
      else if (equipment.category == "Wolne ciężary")
        gymFreeWeightsList.add(equipment);
      else if (equipment.category == "Maszyny")
        gymMachinesList.add(equipment);
      else if (equipment.category == "Akcesoria")
        gymAccessoriesList.add(equipment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "Wyposażenie siłowni:",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
              future: initializelists(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return LoadingSpinnerPage();
                } else {
                  return Column(
                    children: [
                      _Category(category: "CARDIO", gymGearList: gymCardioList),
                      _Category(
                          category: "Wolne ciężary",
                          gymGearList: gymFreeWeightsList),
                      _Category(
                          category: "Maszyny", gymGearList: gymMachinesList),
                      _Category(
                          category: "Akcesoria",
                          gymGearList: gymAccessoriesList),
                    ],
                  );
                }
              }),
        ],
      ),
    ));
  }
}

class _GeneralInfoTab extends StatelessWidget {
  List<String>? workingHours;
  Contact? contact;

  _GeneralInfoTab(
      {super.key, required this.workingHours, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Informacje ogólne:",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            _WorkingHours(
              workingHours: workingHours,
            ),
            _Contact(
              contact: contact,
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkingHours extends StatelessWidget {
  List<String>? workingHours;

  _WorkingHours({super.key, required this.workingHours});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 5),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 6.0),
          child: ListTile(
              title: Text(
                "Godziny otwarcia:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: (workingHours != null && workingHours!.length > 0)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Poniedziałek: ${workingHours![0]}"),
                        Text("Wtorek: ${workingHours![1]}"),
                        Text("Środa: ${workingHours![2]}"),
                        Text("Czwartek: ${workingHours![3]}"),
                        Text("Piątek ${workingHours![4]}"),
                        Text("Sobota ${workingHours![5]}"),
                        Text("Niedziela ${workingHours![6]}"),
                      ],
                    )
                  : Text("Brak godzin otwarcia"))),
    );
  }
}

class _Contact extends StatelessWidget {
  Contact? contact;

  _Contact({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 5),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 6.0),
          child: ListTile(
              title: Text(
                "Kontakt:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: (contact != null)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.mail,
                                color: primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                contact!.email,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                contact!.phoneNo,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                contact!.instagramLink,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.facebook,
                                color: primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                contact!.facebookLink,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Text("Brak danych kontaktowych"))),
    );
  }
}

class _Category extends StatelessWidget {
  final List<GymEquipment> gymGearList;
  final String category;

  const _Category(
      {super.key, required this.gymGearList, required this.category});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Divider(),
        Text(
          category,
          style:
              theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        Column(
          children: [
            for (final gymGear in gymGearList)
              _TileEquipment(
                gymGear: gymGear,
              )
          ],
        )
      ],
    );
  }
}

class _TileEquipment extends StatelessWidget {
  GymEquipment gymGear;

  _TileEquipment({required this.gymGear});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(gymGear.name,
                          style: theme.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text(gymGear.description,
                          style: theme.textTheme.bodyMedium),
                      Text("Ilość: ${gymGear.quantity}",
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(25),
                child: GestureDetector(
                    onTap: () => showInfoDialog(
                        context,
                        gymGear.name,
                        gymGear.description,
                        gymGear.quantity,
                        gymGear.imgUrl ?? "https://via.placeholder.com/100"),
                    child: Icon(
                      Icons.info_rounded,
                      color: theme.primaryColor,
                    )))
          ],
        ),
      ),
    );
  }

  void showInfoDialog(BuildContext context, String name, String description,
      int quantity, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informacje'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nazwa: $name'),
                Text('Opis: $description'),
                Text('Ilość: $quantity'),
                SizedBox(height: 16.0),
                Image.network(
                  imageUrl,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Zamknij'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
