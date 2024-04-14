import 'dart:convert';

import 'package:fitfinder/API/training/TrainingAPI.dart';
import 'package:fitfinder/main_page/additional_pages/common/AdditionalScreenScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../API/training/model/Workout.dart';
import '../../../general/Calendar.dart';
import '../../../general/NavigationAnimation.dart';
import 'AddWorkout.dart';

class MyWorkout extends StatefulWidget {
  @override
  State<MyWorkout> createState() => _MyWorkoutState();

  static _MyWorkoutState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyWorkoutState>()!;
}

class _MyWorkoutState extends State<MyWorkout> {
  void loadWorkouts() async {
    new TrainingAPI().getAllTrainingDays();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AdditionalScreenScaffoldWithFloatingButton(
      titleOfPage: "Mój plan",
      floatingButtonAction: () async {
        final result = await Navigator.push(context,
            NavigationAnimation.changeScreenWithAnimationRTL(AddWorkout()));
        if (result != null) {
          setState(() {});
          ;
        }
      },
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text("Twój plan treningowy:",
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: new TrainingAPI().getAllTrainingDays(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Wystąpił błąd z połączceniem sieciowym ${snapshot.error}"),
                  );
                } else {
                  if (snapshot.data!.isEmpty) {
                    return NoWorkoutsCard();
                  } else {
                    List<dynamic> jsonList = snapshot.data!;
                    List<Workout> workouts = jsonList
                        .map((workoutJson) => Workout.fromJson(workoutJson))
                        .toList();
                    return Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: ListView(
                        children: [
                          for (Workout workout in workouts)
                            _WorkoutRoutineCard(workout: workout),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void addTraining() {}
}

class _WorkoutRoutineCard extends StatefulWidget {
  _WorkoutRoutineCard({
    super.key,
    required this.workout,
  });

  final Workout workout;
  bool isTrainingCompleted = false;

  @override
  State<_WorkoutRoutineCard> createState() => _WorkoutRoutineCardState();
}

class _WorkoutRoutineCardState extends State<_WorkoutRoutineCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      '${CalendarWeek.getDayOfWeek(widget.workout.dayOfWeek).toUpperCase()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize),
                    ),
                    Checkbox(
                        value: widget.isTrainingCompleted,
                        onChanged: (value) => {
                              setState(() {
                                widget.isTrainingCompleted = value!;
                              })
                            })
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  '${widget.workout.name}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.workout.exercises.map((exercise) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${exercise.name}'.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Serie: ${exercise.sets}'),
                        Text(
                            'Powtórzenia: ${exercise.reps.toString().replaceAll("[", "").replaceAll("]", "")}'),
                        Text('Obciążenie: ${exercise.weights[0]}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              alignment: Alignment.center,
              icon: Icon(Icons.remove_circle_outlined, color: Colors.red),
              onPressed: () {
                MyWorkout.of(context).loadWorkouts();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NoWorkoutsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Niestety nie posiadasz jeszcze treningów :(",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Spróbuj je dodać guzikiem poniżej",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
