import 'package:fitfinder/API/gym/GymAPI.dart';
import 'package:fitfinder/API/user/UserAPI.dart';
import 'package:flutter/material.dart';

import '../../../API/gym/model/Gym.dart';
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

  @override
  void initState() {
    fetchFavouriteStatus();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _GeneralInfoTab(),
          _GymEquipmentTab(gym: widget.gym),
        ],
      ),
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
  const _GeneralInfoTab({
    super.key,
  });

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
            _WorkingHours(),
            _Contact(),
          ],
        ),
      ),
    );
  }
}

class _WorkingHours extends StatelessWidget {
  const _WorkingHours({
    super.key,
  });

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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Poniedziałek: 8:00-23:00"),
                Text("Wtorek: 8:00-23:00"),
                Text("Środa: 8:00-23:00"),
                Text("Czwartek: 8:00-23:00"),
                Text("Piątek 8:00-22:00"),
                Text("Sobota 8:00-16:00"),
                Text("Niedziela 8:00-16:00"),
              ],
            ),
          )),
    );
  }
}

class _Contact extends StatelessWidget {
  const _Contact({
    super.key,
  });

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
            subtitle: Column(
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
                        "FitTest@gmail.com",
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
                        "+48 777 555 222",
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
                        "instagram.com/FitTest",
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
                        "facebook.com/FitTest",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
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
