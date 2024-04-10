import 'package:fitfinder/main_page/additional_pages/MyWorkout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../general/Calendar.dart';
import '../introduction/StartPage.dart';

class MainScreen extends StatelessWidget {
  final List<Map<String, String>> _dataList = [
    {
      'nazwa': 'Firma A',
      'miasto': 'Kraków',
      'ulica': 'ul. Kawiarniana 12',
      'hours': '8:00-22:00',
      'image':
          'https://st2.depositphotos.com/1017228/7108/i/450/depositphotos_71080145-stock-photo-gym-interior-with-equipment.jpg'
    },
    {
      'nazwa': 'Firma B',
      'miasto': 'Warszawa',
      'ulica': 'ul. Handlowa 5',
      'hours': '8:00-24:00',
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/026/781/389/small/gym-interior-background-of-dumbbells-on-rack-in-fitness-and-workout-room-photo.jpg'
    },
    {
      'nazwa': 'Firma C',
      'miasto': 'Gdańsk',
      'ulica': 'ul. Portowa 8',
      'hours': '6:00-22:00',
      'image':
          'https://img.freepik.com/premium-photo/powerful-fitness-gym-background_849761-28993.jpg'
    },
  ];

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
                PageViewBox(
                    dataList: _dataList),
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
                      CardTraining(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Placeholder",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Card(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                // Kolor tła kontenera
                                borderRadius: BorderRadius.circular(10),
                                // Zaokrąglenie rogów kontenera
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    // Kolor cienia
                                    spreadRadius: 3,
                                    // Rozprzestrzenienie cienia
                                    blurRadius: 7,
                                    // Rozmycie cienia
                                    offset: Offset(0, 3), // Offset cienia
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text("Tu coś będzie"),
                                subtitle: Text("Może dostępni trenerzy"),
                              ),
                            )
                          ],
                        ),
                      )
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
  PageViewBox({
    super.key,
    required List<Map<String, String>> dataList,
  })  : _dataList = dataList;

  final List<Map<String, String>> _dataList;
  final PageController _pageController = PageController(
    viewportFraction:
    0.90, // Ustawienie viewportFraction na 0.8 (czyli 80% szerokości ekranu)
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    _dataList[index]['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  title: Text(
                    _dataList[index]['nazwa']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Miasto: ${_dataList[index]['miasto']}'),
                      Text('Ulica: ${_dataList[index]['ulica']}'),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Otwarte dziś: ",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color)),
                          TextSpan(
                              text: _dataList[index]['hours'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color))
                        ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CardTraining extends StatefulWidget {
  CardTraining({
    super.key,
  });

  @override
  State<CardTraining> createState() => _CardTrainingState();
}

class _CardTrainingState extends State<CardTraining> {
  bool isTrainingCompleted = false; // Początkowa wartość Checkboxa
  String trainingTime = "2:00h";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                // Kolor tła kontenera
                borderRadius: BorderRadius.circular(10),
                // Zaokrąglenie rogów kontenera
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), // Kolor cienia
                    spreadRadius: 3, // Rozprzestrzenienie cienia
                    blurRadius: 7, // Rozmycie cienia
                    offset: Offset(0, 3), // Offset cienia
                  ),
                ],
              ),
              child: CalendarWeek()),
          ListTile(
            title: Text(
              "Trening klaty",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Szacowany czas treningu: " + trainingTime),
                Text('Kliknij aby przejść do szczegółów'),
              ],
            ),
            trailing: Checkbox(
              value: isTrainingCompleted,
              onChanged: (newValue) {
                setState(() {
                  isTrainingCompleted = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
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
            "John Doe",
            style: theme.bodyLarge,
          ),
          Text(
            "JohnDoe@gmail.com",
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
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyWorkout()))
          },
          title: const Text("Mój plan"),
        ),
        ListTile(
          leading: const Icon(Icons.fitness_center),
          title: const Text("Moje siłownie"),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Ustawienia"),
        ),
        ListTile(
          leading: const Icon(Icons.message),
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

  void _clearSharedPrefs() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
  }
}
