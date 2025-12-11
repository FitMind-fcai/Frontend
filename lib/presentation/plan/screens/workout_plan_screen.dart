import 'package:flutter/cupertino.dart';

class WorkoutPlanScreen extends StatefulWidget{
  @override
  _WorkoutPlanScreenState  createState() => _WorkoutPlanScreenState();


}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen>{
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Workout Plan'),
      ),
      child: Center(
        child: Text('Workout Plan Content Here'),
      ),
    );
  }
}