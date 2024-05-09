import 'package:fitfinder/API/gym/GymAPI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../API/training/model/Workout.dart';
import '../../common/AdditionalScreenScaffold.dart';
import '../../common/SingleWidgets.dart';

class IntroductionTrainingScreen extends StatefulWidget {
  Workout workout;
  String gymName;
  int gymId;

  IntroductionTrainingScreen({required this.gymId, required this.workout, required this.gymName});

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
                    child: (widget.workout.exercises.length == 0) ?
                    Center(child: Text("Brak ćwiczeń"))
                        :
                    Column(
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
        floatingActionButton: _ActionButtonAddEquipment(widget.gymId, widget.workout, widget.gymName));
  }
}

class _ActionButtonAddEquipment extends StatelessWidget {
  Workout workout;
  String gymName;
  int gymId;

  _ActionButtonAddEquipment(this.gymId, this.workout, this.gymName);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        new GymAPI().setTraining(gymId, gymName, workout.exercises);
        Navigator.of(context).pop();
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
