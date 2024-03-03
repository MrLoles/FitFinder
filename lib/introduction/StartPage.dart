import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.35), BlendMode.darken),
                image: AssetImage("assets/images/login-background.png"),
                fit: BoxFit.cover)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoContainer(),
            LoginInputField(
              inputName: localization.emailInput,
              isPassword: false,
              icon: const Icon(Icons.mail),
            ),
            const SizedBox(height: 10.0),
            LoginInputField(
              inputName: localization.passwordInput,
              isPassword: true,
              icon: const Icon(Icons.lock),
            ),
            const SizedBox(height: 10.0),
            LoginButton(localization: localization),
            const ForgotPassword(),
            const GoogleSignUp(),
            RichText(
              text: TextSpan(
                text: localization.noAccount + " ",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: localization.registerNow,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                      decorationColor: Colors.blue
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {print("TEST");},
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.localization,
  });

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: () {
          print("TODO");
        },
        child: Text(localization.btnLogin), // Tekst na przycisku
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
        onPressed: () => {print("TODO")},
        icon: Image.asset(
          'assets/images/googleButtonIcon.png',
          height: 24.0,
        ), // Wstawienie ikony Google
        label: Text(
          localization.googleSignUp,
          style: TextStyle(color: Colors.black), // Kolor tekstu przycisku
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, // Kolor tła przycisku
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Zaokrąglone krawędzie przycisku
          ),
        ),
      ),
    );
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
        // Obsługa przycisku "Zapomniałem hasła"
        print("Zapomniałem hasła");
      },
      child: Text(
        localization.forgotPassword,
        style: const TextStyle(
            color: Colors.white,
            decoration: TextDecoration.underline,
            fontSize: 10),
      ),
    );
  }
}

class LoginInputField extends StatelessWidget {
  final String inputName;
  final bool isPassword;
  final Icon icon;

  const LoginInputField(
      {super.key,
      required this.inputName,
      required this.isPassword,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white),
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: inputName,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.65),
        ),
      ),
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
