import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ekran główny"),
        backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
        centerTitle: true,
      ),
      drawer: CustomSidebar(),
    );
  }
}

//TODO delete obie klasy - placeholder
class CustomSidebar extends StatelessWidget {
  const CustomSidebar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: const Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SidebarTopButton(icon: Icons.home_filled,),
                  SidebarTopButton(icon: Icons.call),
                  SidebarTopButton(icon: Icons.chat),
                  SidebarTopButton(icon: Icons.access_alarm),
                ],
              ),
            )),
      ),
    );
  }
}

class SidebarTopButton extends StatelessWidget {
  final IconData icon;

  const SidebarTopButton({
    super.key, required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            print("TEST");
          },
          icon: Icon(icon)),
    );
  }
}