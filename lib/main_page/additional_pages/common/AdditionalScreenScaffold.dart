import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  List<Widget>? actions;

  CustomAppBar({
    required this.title,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    Color primary = Theme
        .of(context)
        .primaryColor;

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => {Navigator.pop(context)},
      ),
      title: Text(title),
      backgroundColor: primary,
      centerTitle: true,
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AdditionalScreenScaffold extends StatelessWidget {
  final String titleOfPage;
  final FloatingActionButton? floatingButton;
  final Widget body;

  AdditionalScreenScaffold(
      {required this.titleOfPage, this.floatingButton, required this.body});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: ValueKey(DateTime.now()),
        appBar: CustomAppBar(title: titleOfPage),
        floatingActionButton: floatingButton ?? null,
        body: body);
  }
}

class AdditionalScreenScaffoldWithFloatingButton
    extends AdditionalScreenScaffold {
  final String titleOfPage;
  final VoidCallback floatingButtonAction;
  final Widget body;

  AdditionalScreenScaffoldWithFloatingButton(
      {required this.titleOfPage, required this.floatingButtonAction, required this.body})
      : super(titleOfPage: titleOfPage, body: body);

  @override
  Widget build(BuildContext context) {
    Color primary = Theme
        .of(context)
        .primaryColor;

    return AdditionalScreenScaffold(
      titleOfPage: titleOfPage,
      floatingButton: FloatingActionButton(
        onPressed: floatingButtonAction,
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primary,
      ),
      body: body,);
  }
}