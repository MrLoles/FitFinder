import 'dart:convert';

import 'package:fitfinder/main_page/additional_pages/AddWorkout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../API/model/workout/Workout.dart';
import '../../general/Calendar.dart';
import '../../general/NavigationAnimation.dart';

class MyWorkout extends StatelessWidget {
  String jsonStr =
      '[{"dayOfWeek":1,"name":"Klatka i biceps","exercises":[{"name":"wyciskanie na ławce poziomej","sets":"5","reps":"10,8,6,4,4","weights":"60kg,80kg,100kg,120kg,120kg","rest":"60sec, 60sec,120sec,120sec,120sec"},{"name":"wyciskanie hantli na ławce ukośnej","sets":"3","reps":"10,10,10","weights":"20kg,20kg,20kg","rest":"60sec,60sec,60sec"}]},{"dayOfWeek":2,"name":"Nogi i brzuch","exercises":[{"name":"przysiady","sets":"3","reps":"10,10,10","weights":"20kg,20kg,20kg","rest":"60sec,60sec,60sec"},{"name":"wyciskanie nogami","sets":"3","reps":"10,10,10","weights":"40kg,40kg,40kg","rest":"60sec,60sec,60sec"}]},{"dayOfWeek":3,"name":"Plecy","exercises":[{"name":"Podciąganie na drązku","sets":"3","reps":"10,10,10","weights":"0kg","rest":"120sec,120sec,120sec"},{"name":"Wyciąg górny drążek wąski","sets":"3","reps":"10,10,10","weights":"50kg,50kg,50kg","rest":"60sec,60sec,60sec"}]}]';

  @override
  Widget build(BuildContext context) {
    List<dynamic> jsonList = jsonDecode(jsonStr);
    List<Workout> workouts =
        jsonList.map((workoutJson) => Workout.fromJson(workoutJson)).toList();

    Color primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Text("Mój plan"),
        backgroundColor: primary,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, NavigationAnimation.changeScreenWithAnimationRTL(AddWorkout())),
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primary,
      ),
      body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text("Twój plan treningowy:",
                      style: Theme.of(context).textTheme.headlineSmall)),
              for (Workout workout in workouts)
                _WorkoutRoutineCard(workout: workout),
              SizedBox(
                height: 20,
              ),
            ],
          )),
    );
  }

  void addTraining(){

  }
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
                // Obsługa zdarzenia zamknięcia karty
              },
            ),
          ),
        ],
      ),
    );
  }
}
