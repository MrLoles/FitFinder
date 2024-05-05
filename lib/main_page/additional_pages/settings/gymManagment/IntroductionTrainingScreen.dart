import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../API/training/model/Workout.dart';
import '../../common/AdditionalScreenScaffold.dart';
import '../../common/SingleWidgets.dart';

class IntroductionTrainingScreen extends StatefulWidget {
  Workout workout;

  IntroductionTrainingScreen({required this.workout});

  @override
  State<IntroductionTrainingScreen> createState() =>
      _IntroductionTrainingScreenState();
}

class _IntroductionTrainingScreenState
    extends State<IntroductionTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
        appBar: CustomAppBar(
          title: "Edytuj trening wprowadzający",
          actions: [],
        ),
        body: Column(children: [
          SizedBox(
            height: 5,
          ),
          Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.workout.exercises.map((exercise) {
                        return Stack(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${exercise.name}'.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Serie: ${exercise.sets}'),
                              Text(
                                  'Powtórzenia: ${exercise.reps.toString().replaceAll("[", "").replaceAll("]", "")}'),
                              Text('Obciążenie: ${exercise.weights}'),
                              Divider(),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.workout.exercises.remove(exercise);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )))
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              )),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddExerciseDialog(
                    onSave: (exercise) {
                      setState(() {
                        widget.workout.exercises.add(exercise);
                      });
                    },
                  );
                },
              );
            },
            child: Text(
              "Dodaj ćwiczenie",
              style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.primaryColor,
                  decoration: TextDecoration.underline,
                  decorationColor: theme.primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          )
        ]),
        floatingActionButton: _ActionButtonAddEquipment());
  }
}

class _ActionButtonAddEquipment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {

      },
      shape: CircleBorder(),
      child: Icon(
        Icons.save,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
