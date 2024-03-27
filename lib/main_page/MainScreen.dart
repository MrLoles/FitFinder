import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ekran główny"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      drawer: CustomSidebar(),
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
              CircleAvatar(radius: 52, backgroundImage: NetworkImage('https://cdn3.iconfinder.com/data/icons/design-n-code/100/272127c4-8d19-4bd3-bd22-2b75ce94ccb4-512.png')),
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
          Text("John Doe", style: theme.bodyLarge,),
          Text("JohnDoe@gmail.com", style: theme.bodyMedium,)
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
        )
      ],
    );
  }
}
