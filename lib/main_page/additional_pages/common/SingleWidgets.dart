import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../API/gym/model/Gym.dart';
import '../../../API/training/model/Workout.dart';

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
                        text: gym.openingHours![DateTime.now().weekday - 1],
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

class AddExerciseDialog extends StatefulWidget {
  final Function(Exercise) onSave;

  AddExerciseDialog({required this.onSave});

  @override
  _AddExerciseDialogState createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController weightsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Dodaj ćwiczenie:'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nazwa ćwiczenia'),
                validator: _textValidator,
              ),
              TextFormField(
                controller: setsController,
                decoration: InputDecoration(labelText: 'Ilość serii'),
                validator: _textValidator,
              ),
              TextFormField(
                controller: repsController,
                decoration: InputDecoration(labelText: 'Ilość powtórzeń'),
                validator: _textValidator,
              ),
              TextFormField(
                controller: weightsController,
                decoration: InputDecoration(labelText: 'Obciążenie'),
                validator: _textValidator,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Anuluj'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              String name = nameController.text;
              String sets = setsController.text;
              String reps = repsController.text;
              String weights = weightsController.text;

              widget.onSave(new Exercise(
                  name: name,
                  sets: sets,
                  reps: reps,
                  weights: weights,
                  rest: ""));

              Navigator.of(context).pop();
            }
          },
          child: Text('Zapisz'),
        ),
      ],
    );
  }

  String? _textValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pole nie może być puste';
    }
    return null;
  }
}