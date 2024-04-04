import 'package:fitfinder/API/Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../general/LoadingSpinner.dart';
import 'StartPage.dart';
import 'common/StartPageCommon.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController loginController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController repeatPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loginController = new TextEditingController();
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    repeatPasswordController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return StartPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/singleLogo.png"),
            Text(localization.registerTitle,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                )),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(inputName: "Login", icon: const Icon(Icons.accessibility_new), controller: loginController,),
                    EmailInput(inputName: "Email", icon: const Icon(Icons.email), emailController: emailController,),
                    RegisterPassword(inputName: localization.passwordInput, icon: const Icon(Icons.lock), controller: passwordController, passwordController: repeatPasswordController, isPassword: true,),
                    RegisterPassword(inputName: localization.repeatPasswordInput, icon: const Icon(Icons.lock), controller: repeatPasswordController, passwordController: passwordController, isPassword: true,),
                    SizedBox(height: 8,),
                    ElevatedButton(onPressed: () => _registerUser(_formKey, loginController, emailController, passwordController),
                        child: Text(localization.registerButton)),
                    TextButton(onPressed: ()=>Navigator.of(context).pop(),
                        style: ButtonStyle(
                        ),
                        child: Text(localization.back,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                              decoration: TextDecoration.underline,
                              decorationThickness: 1,
                              decorationColor: Colors.white,
                              color: Colors.white),)),
                  ],
                ),
              ),
            )
          ],
        )
      )
    );
  }

  void _registerUser(GlobalKey<FormState> formKey, TextEditingController login, TextEditingController email, TextEditingController password){
    if(formKey.currentState!.validate()) {
      showDialog(
        barrierDismissible: false,
        builder: (ctx) {
          return LoadingSpinnerDialog();
          },
        context: context,
      );

      final Future<int> registerStatus = new AuthService().register(login.text, email.text, password.text);

      registerStatus.then((result){
        Navigator.of(context).pop();
        if(result == 201){
          _showSuccessDialog(context);
        } else if(result == 400){
          _showFailedRegistrationDialog(context, true);
        } else{
          _showFailedRegistrationDialog(context, false);
        }
      });


    }
  }

  void _showSuccessDialog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.dialogTitleSuccessRegistration),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(localization.dialogDescriptionpt1SuccessRegistration),
                Text(localization.dialogDescriptionpt2SuccessRegistration),
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

  void _showFailedRegistrationDialog(BuildContext context, bool busyEmail) {
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.dialogTitleFailRegistration),
          content: Text(busyEmail ? localization.dialogSubtitleFailRegistrationEmail : localization.dialogSubtitleFailRegistration),
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
