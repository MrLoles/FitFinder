import 'package:fitfinder/introduction/StartPage.dart';
import 'package:fitfinder/themes/fitfinder_main_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'introduction/OnBoardingScreen.dart';
import 'l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFinder',
      theme: FitFinderProTheme.buildTheme(),
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final prefs = snapshot.data as SharedPreferences;
            final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
            return seenOnboarding ? StartPage() : OnBoardingScreen();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class Start extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StartState();
}

class _StartState extends State<Start> {
  bool firstLaunch = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    setState(() {
      firstLaunch = sharedPreferences.getBool("seenOnboarding") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return firstLaunch ? OnBoardingScreen() : StartPage();
  }
}
