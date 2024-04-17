import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../API/gym/model/Gym.dart';

class GymCard extends StatelessWidget{
  Gym gym;

  GymCard({required this.gym});

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
              gym.imgUrl!,
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            title: Text(
              gym.gymName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Miasto: ${gym.address.city}'),
                Text('Ulica: ${gym.address.street}'),
                if(gym.openingHours != null) RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Otwarte dziś: ",
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .color)),
                    TextSpan(
                        text: gym.openingHours![DateTime.now().weekday],
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