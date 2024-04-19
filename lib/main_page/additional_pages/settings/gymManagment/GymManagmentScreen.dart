import 'package:fitfinder/API/gym/GymAPI.dart';
import 'package:fitfinder/API/gym/model/GymInformationWithEquipment.dart';
import 'package:fitfinder/API/user/model/AdministratedGyms.dart';
import 'package:fitfinder/main_page/additional_pages/common/AdditionalScreenScaffold.dart';
import 'package:fitfinder/main_page/additional_pages/settings/gymManagment/AddEquipmentScreen.dart';
import 'package:flutter/material.dart';

import '../../../../API/gym/model/Gym.dart';
import '../../../../general/LoadingSpinner.dart';

class GymManagmentScreen extends StatelessWidget {
  AdministratedGym administratedGym;
  late _GymEquipment gymEquipment;

  GymManagmentScreen({required this.administratedGym});

  @override
  Widget build(BuildContext context) {
    gymEquipment = new _GymEquipment(administratedGym.id);

    return AdditionalScreenScaffoldWithFloatingButton(
      titleOfPage: administratedGym.gymName,
      body: Column(children: [
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
      ]),
      floatingButtonAction: () async {
        final value = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddEquipmentScreen(administratedGym.id)));
        gymEquipment.key.currentState?.setState(() {});
      },
    );
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
  late GymInformationWithEquipment gymInformationWithEquipment;

  final List<GymEquipment> gymCardioList = [];
  final List<GymEquipment> gymFreeWeightsList = [];
  final List<GymEquipment> gymMachinesList = [];
  final List<GymEquipment> gymAccessoriesList = [];

  Future<void> initializelists() async {
    gymInformationWithEquipment =
        await new GymAPI().getInformationWithEquipment(widget.gymId);

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
  }
}
