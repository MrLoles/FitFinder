import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../API/gym/Gym.dart';

class GymCard extends StatelessWidget{
  String imageLink;
  String gymName;
  Address address;
  String? openingHours;

  GymCard({required this.imageLink, required this.gymName, required this.address, this.openingHours});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            child: Image.network(
              imageLink,
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            title: Text(
              gymName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Miasto: ${address.city}'),
                Text('Ulica: ${address.street}'),
                if(openingHours != null) RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Otwarte dziś: ",
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .color)),
                    TextSpan(
                        text: openingHours,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .color))
                  ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}