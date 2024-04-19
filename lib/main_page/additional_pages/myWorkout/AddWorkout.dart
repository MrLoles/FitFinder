import 'dart:convert';

import 'package:fitfinder/API/training/TrainingAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../API/training/model/Workout.dart';
import '../../../general/Calendar.dart';
import '../../../general/LoadingSpinner.dart';

class AddWorkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Text("Dodaj trening"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: AddWorkoutBody(),
    );
  }
}

class AddWorkoutBody extends StatefulWidget {
  @override
  State<AddWorkoutBody> createState() => _AddWorkoutBodyState();
}

class _AddWorkoutBodyState extends State<AddWorkoutBody> {
  MyDropdownWidget myDropdownWidget = new MyDropdownWidget();

  ExercisesCards exercisesCards = new ExercisesCards();

  final _formKey = GlobalKey<FormState>();

  TextEditingController trainingNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle fontStyle = Theme.of(context).textTheme.bodyLarge!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Dzień tygodnia: ", style: fontStyle),
                      SizedBox(
                        width: 15,
                      ),
                      myDropdownWidget
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Nazwa treningu: ",
                    style: fontStyle,
                  ),
                  Container(
                    width: 250,
                    child: TextFormField(
                      style: fontStyle,
                      maxLength: 30,
                      decoration: InputDecoration(
                        counterText: '',
                        // Wyłącz domyślny licznik znaków
                        suffix: Text('0/30'),
                        // Ustaw niestandardowy licznik znaków
                        suffixStyle: TextStyle(
                            color: Colors.grey), // Styl dla licznika znaków
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return 'Wypełnij pole';
                        }
                        return null;
                      },
                      controller: trainingNameController,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Ćwiczenia: ",
                      style: fontStyle.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(child: SingleChildScrollView(child: exercisesCards)),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _saveTraining(_formKey);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              child: Container(
                child: Text(
                  'Zapisz',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveTraining(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      showDialog(
        barrierDismissible: false,
        builder: (ctx) {
          return LoadingSpinnerDialog();
        },
        context: context,
      );

      Workout workout = new Workout(
          dayOfWeek:
              CalendarWeek.dayOfWeekFromString(myDropdownWidget.selectedDay),
          name: trainingNameController.text,
          exercises: exercisesCards.exerciseList);

      final Future<String> saveTrainingStatus =
          new TrainingAPI().addTrainingDay(workout);

      saveTrainingStatus.then((result) {
        Navigator.of(context).pop();
        if (result == "Success") {
          _showSuccessDialog(context);
        } else {
          _showFailedDialog(context);
        }
      }).catchError((error) {
        Navigator.of(context).pop();
        _showFailedDialog(context);
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.dialogTitleSuccessRegistration),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Zapis treningu zakończony pomyślnie"),
                Text("Kliknij ok aby wrócić do ekranu z treningami"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, "Success");
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFailedDialog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ups, coś poszło nie tak"),
          content: Text("Spróbuj ponownie"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localization.dialogRetryFailRegistration),
            ),
          ],
        );
      },
    );
  }
}

class ExercisesCards extends StatefulWidget {
  List<Exercise> exerciseList = [];

  ExercisesCards({
    super.key,
  });

  @override
  State<ExercisesCards> createState() => _ExercisesCardsState();

  static _ExercisesCardsState of(BuildContext context) =>
      context.findAncestorStateOfType<_ExercisesCardsState>()!;
}

class _ExercisesCardsState extends State<ExercisesCards> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  String jsonStr =
      '[{"name":"Podciąganie na drązku","sets":"3","reps":"10,10,10","weights":"0kg","rest":"120sec,120sec,120sec"},{"name":"Wyciąg górny drążek wąski","sets":"3","reps":"10,10,10","weights":"50kg,50kg,50kg","rest":"60sec,60sec,60sec"},{"name":"przysiady","sets":"3","reps":"10,10,10","weights":"20kg,20kg,20kg","rest":"60sec,60sec,60sec"},{"name":"wyciskanie nogami","sets":"3","reps":"10,10,10","weights":"40kg,40kg,40kg","rest":"60sec,60sec,60sec"}]';

  @override
  void initState() {
    List<dynamic> jsonList = jsonDecode(jsonStr);
    List<Exercise> exerciseListTemp =
        jsonList.map((workoutJson) => Exercise.fromJson(workoutJson)).toList();
    widget.exerciseList.addAll(exerciseListTemp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (Exercise exercise in widget.exerciseList)
            SingleExerciseCard(exercise: exercise),
          IconButton(
              icon: Icon(Icons.add_circle_outline_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddDataDialog(
                      onSave: addExerciseToCards,
                    );
                  },
                );
              }),
        ],
      ),
    );
  }

  void addExerciseToCards(Exercise exercise) {
    setState(() {
      widget.exerciseList.add(exercise);
    });
  }

  void removeExerciseFromList(Exercise exercise) {
    setState(() {
      widget.exerciseList.remove(exercise);
    });
  }
}

class AddDataDialog extends StatefulWidget {
  final Function(Exercise) onSave;

  AddDataDialog({required this.onSave});

  @override
  _AddDataDialogState createState() => _AddDataDialogState();
}

class _AddDataDialogState extends State<AddDataDialog> {
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

class SingleExerciseCard extends StatefulWidget {
  final Exercise exercise;

  const SingleExerciseCard({super.key, required this.exercise});

  @override
  State<SingleExerciseCard> createState() => _SingleExerciseCardState();
}

class _SingleExerciseCardState extends State<SingleExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nazwa ćwiczenia: ${widget.exercise.name}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Ilość serii: ${widget.exercise.sets}'),
                  Text('Powtórzenia: ${widget.exercise.reps}'),
                  Text('Obciążenie: ${widget.exercise.weights}'),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                _deleteExercise();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteExercise() {
    setState(() {
      ExercisesCards.of(context).removeExerciseFromList(widget.exercise);
    });
  }
}
