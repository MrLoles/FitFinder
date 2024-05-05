import 'package:fitfinder/API/gym/GymAPI.dart';
import 'package:fitfinder/API/gym/model/Contact.dart';
import 'package:fitfinder/API/gym/model/GymInformationWithEquipment.dart';
import 'package:fitfinder/API/training/model/Workout.dart';
import 'package:fitfinder/API/user/model/AdministratedGyms.dart';
import 'package:fitfinder/main_page/additional_pages/common/AdditionalScreenScaffold.dart';
import 'package:fitfinder/main_page/additional_pages/settings/gymManagment/AddEquipmentScreen.dart';
import 'package:flutter/material.dart';

import '../../../../API/gym/model/Gym.dart';
import '../../../../general/LoadingSpinner.dart';
import 'IntroductionTrainingScreen.dart';

class GymManagmentScreen extends StatefulWidget {
  AdministratedGym administratedGym;

  GymManagmentScreen({required this.administratedGym});

  static _GymManagmentScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_GymManagmentScreenState>()!;

  @override
  State<GymManagmentScreen> createState() => _GymManagmentScreenState();
}

class _GymManagmentScreenState extends State<GymManagmentScreen>
    with SingleTickerProviderStateMixin {
  late _GymEquipment gymEquipment;
  late GymInformation gymInformation = GymInformation.defaultBuilder();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    gymEquipment = new _GymEquipment(widget.administratedGym.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.administratedGym.gymName,
        actions: [],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AddEquipmentTab(
            gymEquipment: gymEquipment,
          ),
          _InformationTab(
              gymInformation: gymInformation,
              gymId: widget.administratedGym.id),
          _TrainingTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_sharp),
            label: 'Wyposażenie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Informacje',
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
      floatingActionButton: () {
        print(_tabController.index);
        if (_tabController.index == 0)
          return _ActionButtonAddEquipment(
            gymEquipment: gymEquipment,
            id: widget.administratedGym.id,
          );
        else if (_tabController.index == 1)
          return _ActionButtonSave();
        else if (_tabController.index == 2) return _ActionButtonEditTraining();
      }(),
    );
  }
}

class _AddEquipmentTab extends StatelessWidget {
  const _AddEquipmentTab({
    required this.gymEquipment,
  });

  final _GymEquipment gymEquipment;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
          child: Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Edytuj wyposażenie siłowni:",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ))),
      gymEquipment
    ]);
  }
}

class _GymEquipment extends StatefulWidget {
  final GlobalKey<_GymEquipmentState> key = GlobalKey<_GymEquipmentState>();
  final _GymEquipmentState state = _GymEquipmentState();
  int gymId;

  _GymEquipment(this.gymId);

  @override
  State<_GymEquipment> createState() => _GymEquipmentState();

  static _GymEquipmentState of(BuildContext context) =>
      context.findAncestorStateOfType<_GymEquipmentState>()!;
}

class _GymEquipmentState extends State<_GymEquipment> {
  late GymInformation gymInformationWithEquipment;

  final List<GymEquipment> gymCardioList = [];
  final List<GymEquipment> gymFreeWeightsList = [];
  final List<GymEquipment> gymMachinesList = [];
  final List<GymEquipment> gymAccessoriesList = [];

  Future<void> initializelists() async {
    gymInformationWithEquipment =
        await new GymAPI().getGymInformation(widget.gymId);

    GymManagmentScreen.of(context).gymInformation = gymInformationWithEquipment;

    gymCardioList.clear();
    gymFreeWeightsList.clear();
    gymMachinesList.clear();
    gymAccessoriesList.clear();
    List<GymEquipment> gymEquipmentList =
        gymInformationWithEquipment.gymEquipmentList;
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
    return FutureBuilder(
        future: initializelists(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: LoadingSpinnerPage());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ups, coś poszło nie tak :("));
          } else {
            return Container(
              child: Expanded(
                child: ListView(
                  children: [
                    _Category(
                        category: "CARDIO",
                        gymGearList: gymCardioList,
                        gymId: widget.gymId),
                    _Category(
                        category: "Wolne ciężary",
                        gymGearList: gymFreeWeightsList,
                        gymId: widget.gymId),
                    _Category(
                        category: "Maszyny",
                        gymGearList: gymMachinesList,
                        gymId: widget.gymId),
                    _Category(
                        category: "Akcesoria",
                        gymGearList: gymAccessoriesList,
                        gymId: widget.gymId),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}

class _Category extends StatelessWidget {
  int gymId;
  final List<GymEquipment> gymGearList;
  final String category;

  _Category(
      {super.key,
      required this.gymGearList,
      required this.category,
      required this.gymId});

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
                gymId: gymId,
              )
          ],
        )
      ],
    );
  }
}

class _TileEquipment extends StatelessWidget {
  int gymId;
  GymEquipment gymGear;

  _TileEquipment({required this.gymGear, required this.gymId});

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
                    onTap: () => deleteEquipment(context, gymId, gymGear.id),
                    child: Icon(
                      Icons.delete,
                      color: theme.primaryColor,
                    )))
          ],
        ),
      ),
    );
  }

  deleteEquipment(BuildContext context, int gymId, int equipmentId) async {
    new GymAPI().deleteGymEquipment(gymId, equipmentId);
    _GymEquipment.of(context).setState(() {});
    ;
  }
}

class _InformationTab extends StatelessWidget {
  GymInformation gymInformation;
  int gymId;

  _InformationTab(
      {super.key, required this.gymInformation, required this.gymId});

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
            _WorkingHours(gymInformation: gymInformation, gymId: gymId),
            // _WorkingHours(),
            _Contact(gymInformation: gymInformation, gymId: gymId),
          ],
        ),
      ),
    );
  }
}

class _WorkingHours extends StatefulWidget {
  GymInformation gymInformation;
  late List<String>? workingHours;
  int gymId;

  // List<String> workingHours = [
  //   "8:00-23:00",
  //   "8:00-23:00",
  //   "8:00-23:00",
  //   "8:00-23:00",
  //   "8:00-23:00",
  //   "8:00-18:00",
  //   "8:00-16:00"
  // ];

  _WorkingHours(
      {super.key, required this.gymInformation, required this.gymId}) {
    workingHours = gymInformation.openingHours;
  }

  @override
  State<_WorkingHours> createState() => _WorkingHoursState();
}

class _WorkingHoursState extends State<_WorkingHours> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 5),
        child: Card(
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            child: isLoading
                ? LoadingSpinnerPage()
                : Stack(children: [
                    ListTile(
                        title: Text(
                          "Godziny otwarcia:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: () {
                          if (widget.workingHours != null &&
                              widget.workingHours!.length > 6) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Poniedziałek: ${widget.workingHours![0]}"),
                                Text("Wtorek: ${widget.workingHours![1]}"),
                                Text("Środa: ${widget.workingHours![2]}"),
                                Text("Czwartek: ${widget.workingHours![3]}"),
                                Text("Piątek: ${widget.workingHours![4]}"),
                                Text("Sobota: ${widget.workingHours![5]}"),
                                Text("Niedziela: ${widget.workingHours![6]}"),
                              ],
                            );
                          } else {
                            return Text(
                              "Aktualnie nie masz ustawionych\ngodzin otwarcia, aby je ustawić \nkliknij w guzik po prawej stronie",
                            );
                          }
                        }()),
                    _EditButton(
                        icon: Icons.edit_calendar_outlined,
                        onPressed: () {
                          showEditOpeningHoursDialog(
                              context, widget.workingHours!);
                        }),
                  ])));
  }

  Future<void> updateGymInformation() async {
    widget.gymInformation = await new GymAPI().getGymInformation(widget.gymId);
    setState(() {
      widget.workingHours = widget.gymInformation.openingHours;
    });
  }

  void showEditOpeningHoursDialog(
      BuildContext context, List<String> workingHours) {
    TextEditingController mondayController = new TextEditingController();
    TextEditingController tuesdayController = new TextEditingController();
    TextEditingController wednesdayController = new TextEditingController();
    TextEditingController thursdayController = new TextEditingController();
    TextEditingController fridayController = new TextEditingController();
    TextEditingController saturdayController = new TextEditingController();
    TextEditingController sundayController = new TextEditingController();

    void showLoadingDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingSpinnerDialog();
        },
      );
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Zmień godziny otwarcia"),
            content: SizedBox(
                height: 350,
                child: () {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _EditableRowDialog(
                            name: "Poniedziałek: ",
                            value: workingHours[0],
                            controller: mondayController),
                        _EditableRowDialog(
                            name: "Wtorek: ",
                            value: workingHours[1],
                            controller: tuesdayController),
                        _EditableRowDialog(
                            name: "Środa: ",
                            value: workingHours[2],
                            controller: wednesdayController),
                        _EditableRowDialog(
                            name: "Czwartek: ",
                            value: workingHours[3],
                            controller: thursdayController),
                        _EditableRowDialog(
                            name: "Piątek: ",
                            value: workingHours[4],
                            controller: fridayController),
                        _EditableRowDialog(
                            name: "Sobota: ",
                            value: workingHours[5],
                            controller: saturdayController),
                        _EditableRowDialog(
                            name: "Niedziela: ",
                            value: workingHours[6],
                            controller: sundayController),
                      ],
                    ),
                  );
                }()),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  Navigator.of(context).pop();
                  if (mondayController.text.isEmpty)
                    mondayController.text = workingHours[0];
                  if (tuesdayController.text.isEmpty)
                    tuesdayController.text = workingHours[1];
                  if (wednesdayController.text.isEmpty)
                    wednesdayController.text = workingHours[2];
                  if (thursdayController.text.isEmpty)
                    thursdayController.text = workingHours[3];
                  if (fridayController.text.isEmpty)
                    fridayController.text = workingHours[4];
                  if (saturdayController.text == "")
                    saturdayController.text = workingHours[5];
                  if (sundayController.text == "")
                    sundayController.text = workingHours[6];
                  await GymAPI().setWorkingHours(
                    widget.gymId,
                    mondayController.text,
                    tuesdayController.text,
                    wednesdayController.text,
                    thursdayController.text,
                    fridayController.text,
                    saturdayController.text,
                    sundayController.text,
                  );
                  await updateGymInformation();
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Text('Zapisz'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Anuluj'),
              ),
            ],
          );
        });
  }
}

class _Contact extends StatefulWidget {
  GymInformation gymInformation;
  int gymId;

  _Contact({super.key, required this.gymInformation, required this.gymId}) {}

  @override
  State<_Contact> createState() => _ContactState();
}

class _ContactState extends State<_Contact> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 5),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 6.0),
          child: isLoading
              ? LoadingSpinnerPage()
              : Stack(children: [
            ListTile(
                title: Text(
                  "Kontakt:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: () {
                  if (widget.gymInformation.contact != null) {
                    return Column(
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
                                widget.gymInformation.contact!.email,
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
                                widget.gymInformation.contact!.phoneNo,
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
                                widget.gymInformation.contact!.instagramLink,
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
                                widget.gymInformation.contact!.facebookLink,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text(
                        "Ustaw dane do kontaktu klikając w guzik po prawej stronie");
                  }
                }()),
            _EditButton(
              icon: Icons.contact_mail,
              onPressed: () {
                _showEditContactDialog(
                    context,
                    widget.gymInformation.contact!.email,
                    widget.gymInformation.contact!.phoneNo,
                    widget.gymInformation.contact!.instagramLink,
                    widget.gymInformation.contact!.facebookLink);
              },
            ),
          ])),
    );
  }

  void _showEditContactDialog(BuildContext context, String mail, String phoneNo,
      String instagramLink, String facebookLink) {
    TextEditingController emailController = new TextEditingController();
    TextEditingController phoneNoController = new TextEditingController();
    TextEditingController instagramController = new TextEditingController();
    TextEditingController facebookController = new TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Zmień dane kontaktowe",
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _EditableRowDialogColumns(
                    name: "Email:",
                    value: mail,
                    controller: emailController,
                  ),
                  _EditableRowDialogColumns(
                    name: "Numer telefonu:",
                    value: phoneNo,
                    controller: phoneNoController,
                  ),
                  _EditableRowDialogColumns(
                    name: "Instagram:",
                    value: instagramLink,
                    controller: instagramController,
                  ),
                  _EditableRowDialogColumns(
                    name: "Facebook:",
                    value: facebookLink,
                    controller: facebookController,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                Navigator.of(context).pop();
                if (emailController.text.isEmpty) emailController.text = mail;
                if (phoneNoController.text.isEmpty)
                  phoneNoController.text = phoneNo;
                if (instagramController.text.isEmpty)
                  instagramController.text = instagramLink;
                if (facebookController.text.isEmpty)
                  facebookController.text = facebookLink;

                await new GymAPI().setContactData(
                    widget.gymId,
                    new Contact(
                        email: emailController.text,
                        phoneNo: phoneNoController.text,
                        instagramLink: instagramController.text,
                        facebookLink: facebookController.text));
                await updateGymInformation();
                setState(() {
                  isLoading = false;
                });
              },
              child: Text('Zapisz'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Anuluj'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateGymInformation() async {
    widget.gymInformation = await new GymAPI().getGymInformation(widget.gymId);
    setState(() {
      widget.gymInformation;
    });
  }
}

class _ActionButtonSave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // final value = await Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => AddEquipmentScreen(widget.administratedGym.id)));
        // gymEquipment.key.currentState?.setState(() {});
      },
      shape: CircleBorder(),
      child: Icon(
        Icons.save,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

class _ActionButtonAddEquipment extends StatelessWidget {
  int id;
  _GymEquipment gymEquipment;

  _ActionButtonAddEquipment({required this.id, required this.gymEquipment});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final value = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddEquipmentScreen(id)));
        gymEquipment.key.currentState?.setState(() {});
      },
      shape: CircleBorder(),
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

class _ActionButtonEditTraining extends StatelessWidget {
  Workout workout =
      new Workout(dayOfWeek: 1, name: "Trening wprowadzający", exercises: [
    Exercise(name: "Wyciskanie", sets: "3", reps: "3, 3, 3", weights: "10kg"),
    Exercise(
        name: "Siady",
        sets: "5",
        reps: "10, 10, 10, 10, 10",
        weights: "40kg, 60kg, 60kg, 40kg, 40kg")
  ]);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final value = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IntroductionTrainingScreen(
                      workout: workout,
                    )));
        () {};
      },
      shape: CircleBorder(),
      child: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

class _TrainingTab extends StatelessWidget {
  Workout workout =
      new Workout(dayOfWeek: 1, name: "Trening wprowadzający", exercises: [
    Exercise(name: "Wyciskanie", sets: "3", reps: "3, 3, 3", weights: "10kg"),
    Exercise(
        name: "Siady",
        sets: "5",
        reps: "10, 10, 10, 10, 10",
        weights: "40kg, 60kg, 60kg, 40kg, 40kg")
  ]);

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: workout.exercises.map((exercise) {
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
                ),
              ),
            ),
          ))
    ]);
  }
}

class _EditButton extends StatelessWidget {
  _EditButton(
      {super.key, required this.icon, required void Function() this.onPressed});

  IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 15,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: IconButton(
            icon: Icon(icon, color: Colors.black),
            onPressed: onPressed,
            color: Colors.white,
            splashColor: Colors.red,
            highlightColor: Colors.grey),
      ),
    );
  }
}

class _EditableRowDialog extends StatelessWidget {
  const _EditableRowDialog(
      {super.key,
      required this.name,
      required this.value,
      required this.controller});

  final String name;
  final String value;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
            width: 150,
            child: TextFormField(
              controller: controller,
              decoration:
                  InputDecoration(hintText: value, border: InputBorder.none),
            ))
      ],
    );
  }
}

class _EditableRowDialogColumns extends StatelessWidget {
  final TextEditingController controller;

  const _EditableRowDialogColumns(
      {Key? key,
      required this.name,
      required this.value,
      required this.controller})
      : super(key: key);

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            name,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 5),
        Center(
          child: Container(
            width: 250,
            child: TextField(
              textAlign: TextAlign.center,
              decoration:
                  InputDecoration(hintText: value, border: InputBorder.none),
              controller: controller,
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
