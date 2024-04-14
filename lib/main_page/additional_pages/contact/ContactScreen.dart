import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primary = Theme
        .of(context)
        .primaryColor;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {Navigator.pop(context)},
          ),
          title: Text("Kontakt"),
          backgroundColor: primary,
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Column(
                  children: [
                    Text("Jeżeli:",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall),
                    Divider(),
                    _ListElementPoint(
                        text: "Masz problem z działaniem aplikacji"),
                    _ListElementPoint(
                        text:
                        "Jesteś właścicielem siłowni i chcesz ją dodać do aplikacji"),
                    _ListElementPoint(
                        text:
                        "Masz jakieś pytania"),
                  ],
                ),
              ),
              Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        child: Text("Skontaktuj się z nami:", style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall),
                      ),
                      ElevatedButton(
                        onPressed: () => _sendEmail('fit.finder2024@gmail.com'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          elevation: 3,
                          padding: EdgeInsets.all(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'fit.finder2024@gmail.com',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Flexible(
                flex: 1,
                child: Image.asset("assets/images/singleLogo.png"),
              ),
            ],
          ),
        ));
  }

  void _sendEmail(String email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    var url = _emailLaunchUri.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class _ListElementPoint extends StatelessWidget {
  String text;

  _ListElementPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
