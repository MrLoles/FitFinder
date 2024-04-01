import 'package:fitfinder/API/Auth.dart';
import 'package:fitfinder/introduction/ForgotPasswordPage.dart';
import 'package:fitfinder/introduction/RegisterPage.dart';
import 'package:fitfinder/main_page/MainScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../general/LoadingSpinner.dart';
import 'common/StartPageCommon.dart';

class StartPage extends StatefulWidget {
  final bool failedLogin;

  StartPage({super.key, this.failedLogin = false});

  @override
  State<StartPage> createState() => _StartPageState(failedLogin);
}

class _StartPageState extends State<StartPage> {
  final bool failedLogin;

  _StartPageState(bool this.failedLogin);

  @override
  void initState() {
    super.initState();
    if(failedLogin){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showLoginFailedDialog(context);
      });
    }
  }

  void showLoginFailedDialog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.dialogBoxTitle),
          content: Text(localization.dialogBoxInfo),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return StartPageScaffold(child: LoginRegisterForm());
  }
}


class LoginRegisterForm extends StatefulWidget {

  LoginRegisterForm({
    super.key,
  });

  @override
  State<LoginRegisterForm> createState() => _LoginRegisterFormState();
}


class _LoginRegisterFormState extends State<LoginRegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController loginController;
  late TextEditingController passwordController;


  @override
  void initState() {
    super.initState();
    loginController = new TextEditingController();
    passwordController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LogoContainer(),
          InputField(
            controller: loginController,
            inputName: localization.emailInput,
            icon: const Icon(Icons.mail),
          ),
          InputField(
            controller: passwordController,
            inputName: localization.passwordInput,
            isPassword: true,
            icon: const Icon(Icons.lock),
          ),
          LoginButton(localization: localization,
            login: loginController,
            password: passwordController,
            formKey: _formKey,),
          const ForgotPassword(),
          const GoogleSignUp(),
          RegisterLabel(localization: localization)
        ],
      )),
    );
  }
}

class LogoContainer extends StatelessWidget {
  const LogoContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
        margin: EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            Image.asset("assets/images/singleLogo.png"),
            Text("FitFinder",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.white,
                )),
            Text(
              localization.startPageSubtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            )
          ],
        ));
  }
}


class LoginButton extends StatelessWidget {
  final AppLocalizations localization;
  final TextEditingController login;
  final TextEditingController password;
  final GlobalKey<FormState> formKey;

  const LoginButton({
    super.key,
    required this.localization,
    required this.login,
    required this.password,
    required this.formKey
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: () {
            if(formKey.currentState!.validate()){
            final Future<String> loginFuture = AuthService()
                .login(login.text, password.text);

            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)
            {
              return FutureBuilder<String>(
                future: loginFuture,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return LoadingSpinnerPage();
                  }
                  else{
                    final token = snapshot.data; //TODO co jak timeout
                    if(token == null || token.isEmpty){
                      return StartPage(failedLogin: true,);
                    }else {
                      saveToken(token);
                      return MainScreen();
                    }
                  }
                },
              );
            }));
          }
        },
        child: Text(localization.btnLogin), // Tekst na przycisku
      ),
    );
  }

  void saveToken(String token) async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", token);
  }
}


class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ForgotPasswordPage(),
            ));
      },
      child: Text(
        localization.forgotPassword,
        style: const TextStyle(
            color: Colors.white,
            decoration: TextDecoration.underline,
            fontSize: 13),
      ),
    );
  }
}

class GoogleSignUp extends StatelessWidget {
  const GoogleSignUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ElevatedButton.icon(
        onPressed: () => {
          Navigator.push(context,
              new MaterialPageRoute(builder: (BuildContext context) {
                return MainScreen();
              }))
        },
        icon: Image.asset(
          'assets/images/googleButtonIcon.png',
          height: 24.0,
        ),
        label: Text(
          localization.googleSignUp,
          style: TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}

class RegisterLabel extends StatelessWidget {
  const RegisterLabel({
    super.key,
    required this.localization,
  });

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: localization.noAccount + " ",
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
            ),
        children: <TextSpan>[
          TextSpan(
            text: localization.registerNow,
            style: const TextStyle(
                color: Colors.blue,
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationThickness: 1,
                decorationColor: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ));
              },
          ),
        ],
      ),
    );
  }
}
