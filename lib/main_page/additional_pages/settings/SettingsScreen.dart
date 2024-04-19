import 'package:fitfinder/main_page/additional_pages/settings/gymManagment/GymManagmentSelectionScreen.dart';
import 'package:flutter/material.dart';

import '../common/AdditionalScreenScaffold.dart';

class SettingsScreen extends StatelessWidget{
  bool isAdmin;

  SettingsScreen(this.isAdmin);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold);

    return AdditionalScreenScaffold(titleOfPage: 'Ustawienia',
        body: Column(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Zmień nazwę użytkownika", style: textStyle),
            ),
            Divider(),
            isAdmin ? Column(
              children: [
                ListTile(leading: Icon(Icons.fitness_center_sharp),
                title: Text("Zarządzane siłownie", style: textStyle),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => GymManagmentSelectionScreen())),
                ),
                Divider()
              ],
            ) : SizedBox(),
            ListTile(
              leading: Icon(Icons.person_remove, color: Colors.red,),
              title: Text("Skasuj konto", style: textStyle.copyWith(color: Colors.red)),
            ),
            Divider(),
          ],
        )
    );
  }
}