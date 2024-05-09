
class Exercise {
  String name;
  String sets;
  String reps;
  String weights;
  String rest;

  Exercise({required this.name, required this.sets, required this.reps, required this.weights, this.rest = "0"});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    String localRest = (json['rest'] == null || json['rest'] == "null" || json['rest'] == "") ? "null" : json['rest'];

    return Exercise(
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      weights: json['weights'],
        rest: localRest
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "sets": sets,
      "reps": reps,
      "weights": weights,
      "rest": rest,
    };
  }
}

class Workout {
  int dayOfWeek;
  String name;
  List<Exercise> exercises;

  Workout({required this.dayOfWeek, required this.name, required this.exercises});

  factory Workout.fromJson(Map<String, dynamic> json) {
    var exercisesList = json['exercises'] as List;
    List<Exercise> exercises = exercisesList.map((exerciseJson) => Exercise.fromJson(exerciseJson)).toList();

    return Workout(
      dayOfWeek: json['dayOfWeek'],
      name: json['name'],
      exercises: exercises,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> exercisesJson = exercises.map((e) => e.toJson()).toList();
    return {
      "dayOfWeek": dayOfWeek,
      "name": name,
      "exercises": exercisesJson
    };
  }

  factory Workout.defaultBuilder(){
    return new Workout(dayOfWeek: 0, name: "notYet", exercises: []);
  }
}