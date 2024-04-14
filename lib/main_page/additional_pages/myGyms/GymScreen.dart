import 'package:flutter/material.dart';

import '../../../API/gym/Gym.dart';
import '../common/AdditionalScreenScaffold.dart';

class GymScreen extends StatefulWidget {
  Gym gym;

  GymScreen(this.gym);

  @override
  State<GymScreen> createState() => _GymScreenState();
}

class _GymScreenState extends State<GymScreen>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  late TabController _tabController;

  @override
  void initState() {
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
            onPressed: () {
              // Dodaj kod obsługujący kliknięcie na serduszko
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _GeneralInfoTab(),
          _GymEquipmentTab(),
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
}

class _GymEquipmentTab extends StatelessWidget {
  final List<GymGear> gymCardioList = [];
  final List<GymGear> gymFreeWeightsList = [];
  final List<GymGear> gymFMachinesList = [];

  _GymEquipmentTab({
    super.key,
  });

  void initializelists() {
    gymCardioList.add(new GymGear(
        name: "Bieżnia",
        category: "CARDIO",
        description: "description",
        quantity: 5,
        imgUrl:
            "https://www.urbogym.pl/wp-content/uploads/2021/09/urbogym1455-1.jpg"));
    gymCardioList.add(new GymGear(
        name: "Rowerek",
        category: "CARDIO",
        description: "description",
        quantity: 3,
        imgUrl:
            "https://a.allegroimg.com/s512/11ecad/cf57b49a42f9a1d87453d9d15228/ROWEREK-STACJONARNY-ROWER-TRENINGOWY-BOOST-ZIPRO"));
    gymCardioList.add(new GymGear(
        name: "Wioślarz",
        category: "CARDIO",
        description: "description",
        quantity: 3,
        imgUrl:
            "https://cdn.sport-shop.pl/p/v1/big/d159073338b34d1eb38a391bb5bddcf9.jpg"));

    gymFreeWeightsList.add(new GymGear(
        name: "Ławka płaska",
        category: "Wolne ciężary",
        description: "description",
        quantity: 4,
        imgUrl:
            "https://trainingshowroom.com/12027-thickbox_default/lawka-plaska-olimpijska-proud-champion.jpg"));
    gymFreeWeightsList.add(new GymGear(
        name: "Skos ujemny",
        category: "Wolne ciężary",
        description: "description",
        quantity: 1,
        imgUrl:
            "https://www.marbo-sport.pl/pol_pl_Lawka-skos-ujemny-ze-stojakami-MF-L008-Marbo-Sport-26513_3.png"));
    gymFreeWeightsList.add(new GymGear(
        name: "Skos dodatni",
        category: "Wolne ciężary",
        description: "description",
        quantity: 2,
        imgUrl:
            "https://www.marbo-sport.pl/data/gfx/pictures/large/8/5/28958_1.jpg"));

    gymFMachinesList.add(new GymGear(
        name: "Butterfly",
        category: "Maszyny",
        description: "description",
        quantity: 4,
        imgUrl:
            "https://cdn.globalso.com/dhzfitness/Butterfly-Machine-U2004C-1.jpg"));
    gymFMachinesList.add(new GymGear(
        name: "Maszyna smitha",
        category: "Maszyny",
        description: "description",
        quantity: 1,
        imgUrl:
            "https://commercial.fitnessexperience.ca/cdn/shop/products/MX21_MAGNUMMG-PL62-03smithmachine_MatteBlk_hero_2048x.jpg?v=1620421828"));
    gymFMachinesList.add(new GymGear(
        name: "Atlas",
        category: "Maszyny",
        description: "description",
        quantity: 2,
        imgUrl:
            "https://ss24.pl/images/ss24/888000-889000/ATLAS-TT4-BLACK-G159B-BH-FITNESS_%5B888280%5D_480.jpg"));
  }

  @override
  Widget build(BuildContext context) {
    initializelists();

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
          _Category(category: "CARDIO", gymGearList: gymCardioList),
          _Category(category: "Wolne ciężary", gymGearList: gymFreeWeightsList),
          _Category(category: "Maszyny", gymGearList: gymFMachinesList),
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

class _TileEquipment extends StatelessWidget {
  GymGear gymGear;

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
                    onTap: () => showInfoDialog(context, gymGear.name,
                        gymGear.description, gymGear.quantity, gymGear.imgUrl),
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

class _Category extends StatelessWidget {
  final List<GymGear> gymGearList;
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
