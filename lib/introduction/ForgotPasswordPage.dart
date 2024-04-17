import 'package:fitfinder/introduction/common/StartPageCommon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../API/auth/Auth.dart';
import '../general/LoadingSpinner.dart';
import 'StartPage.dart';

class ForgotPasswordPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordPageState();
  }
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>{
  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


    return StartPageScaffold(
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                child: Card(
                  color: Colors.black.withOpacity(0.65),
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    child: Column(
                      children: [
                        Text(localization.forgotPasswordDescription1, style: getTextForDescription(context).copyWith(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                        SizedBox(height: 10,),
                        Text(localization.forgotPasswordDescription2, style: getTextForDescription(context),textAlign: TextAlign.center),
                        Text(localization.forgotPasswordDescription3, style: getTextForDescription(context),textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              EmailInput(inputName: "Email", icon: Icon(Icons.email), emailController: emailController),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () => _recoverPassword(_formKey, emailController),
                  child: Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                      child: Text(localization.forgotPasswordButtonSend)
                  )
              ),
              ButtonBack(),
            ],
          ),
        )
      ),
    );
  }

  TextStyle getTextForDescription(BuildContext context){
    return Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white);
  }

  void _recoverPassword(GlobalKey<FormState> formKey, TextEditingController emailController){
    if(formKey.currentState!.validate()){
      showDialog(
        barrierDismissible: false,
        builder: (ctx) {
          return LoadingSpinnerDialog();
        },
        context: context,
      );

      final Future<int> forgotPasswordStatus = new AuthService().forgotPassword(emailController.text);

      forgotPasswordStatus.then((result){
        Navigator.of(context).pop();
        if(result < 499){
          _showSuccessDialog(context);
        } else if (result >= 500){
          _showFailedRegistrationDialog(context);
        }
        // result ? showSuccessDialog(context) : showFailedRegistrationDialog(context);
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.forgotPasswordDialogTitleSuccess),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(localization.forgotPasswordDialogDescription1Success),
                Text(localization.forgotPasswordDialogDescription2Success),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                      return StartPage();
                    }));
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFailedRegistrationDialog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.forgotPasswordDialogTitleFailed),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(localization.forgotPasswordDialogDescription1Fail),
                Text(localization.forgotPasswordDialogDescription2Fail),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localization.dialogRetryFailRegistration),
            ),
          ],
        );
      },
    );
  }
}