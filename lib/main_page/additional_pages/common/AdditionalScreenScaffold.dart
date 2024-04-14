import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdditionalScreenScaffold extends StatelessWidget{
  final String titleOfPage;
  final VoidCallback floatingButtonAction;
  final Widget body;

  AdditionalScreenScaffold({required this.titleOfPage, required this.floatingButtonAction, required this.body});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    return Scaffold(
        key: ValueKey(DateTime.now()),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {Navigator.pop(context)},
          ),
          title: Text(titleOfPage),
          backgroundColor: primary,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: floatingButtonAction,
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: primary,
        ),
        body: body);
  }
}