import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index){
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [
            TextContainer(
              title: AppLocalizations.of(context)!.introduction1_1,
              description: AppLocalizations.of(context)!.introduction1_2,
              color: new Color.fromARGB(152, 220, 115, 10),
            ),
            TextContainer(
              title: AppLocalizations.of(context)!.introduction2_1,
              description: AppLocalizations.of(context)!.introduction2_2,
              color: new Color.fromARGB(152, 152, 115, 253),
            ),
            TextContainer(
              title: AppLocalizations.of(context)!.introduction3_1,
              description: AppLocalizations.of(context)!.introduction3_2,
              color: new Color.fromARGB(152, 75, 115, 253),
            ),
          ],
        ),
        Container(
            alignment: Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(AppLocalizations.of(context)!.skip)),
                SmoothPageIndicator(controller: _controller, count: 3),
                onLastPage?
                GestureDetector(
                    onTap: () {
                      print("TODO");
                    },
                    child: Text(AppLocalizations.of(context)!.done)) :
                GestureDetector(
                    onTap: () {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Text(AppLocalizations.of(context)!.next))
              ],
            ))
      ]),
    );
  }
}

class TextContainer extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const TextContainer({
    super.key,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: color,
        child: Center(
          child: Card(
            elevation: 20,
            margin: EdgeInsets.all(20),
            color: color.withAlpha(600),
            child: ListTile(
              title: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  )),
              subtitle: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
