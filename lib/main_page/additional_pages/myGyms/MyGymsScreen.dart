import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/AdditionalScreenScaffold.dart';

class MyGymsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdditionalScreenScaffold(
      titleOfPage: "Moje siłownie",
      floatingButtonAction: () => {
        print("Test")
      },
      body: Text("Test"),
    );
  }
}