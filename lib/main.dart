import 'package:fitfinder/API/Auth.dart';
import 'package:fitfinder/introduction/StartPage.dart';
import 'package:fitfinder/main_page/MainScreen.dart';
import 'package:fitfinder/themes/fitfinder_main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'general/LoadingSpinner.dart';
import 'introduction/OnBoardingScreen.dart';
import 'l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp2 extends StatelessWidget {
  final List<String> items = List.generate(10, (index) => 'Element ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista Przewijana'),
        ),
        body: PageView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Text(
                items[index],
                style: TextStyle(fontSize: 24.0),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFinder',
      theme: FitFinderProTheme.buildTheme(),
      supportedLocales: L10n.all,
      // locale: const Locale('en'),

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
            final token = prefs.getString("token") ?? null;
            if(token != null){
              return StartPageSelector(token);
            }
            return seenOnboarding ? StartPage() : OnBoardingScreen();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class StartPageSelector extends StatelessWidget{
  final String token;

  StartPageSelector(this.token);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: new AuthService().validateToken(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LoadingSpinnerPage();
        }
        else {
          // bool tokenLogin = snapshot.data ?? false; //TODO uncomment automatyczane logowanie
          // return tokenLogin ? MainScreen() : StartPage();
          return StartPage();
        }
      },
    );
    return FutureBuilder<bool>(
      future: new AuthService().validateToken(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LoadingSpinnerPage();
        }
        else {
          bool tokenLogin = snapshot.data ?? false;
          return tokenLogin ? MainScreen() : StartPage();
        }
      },
    );
  }
}
