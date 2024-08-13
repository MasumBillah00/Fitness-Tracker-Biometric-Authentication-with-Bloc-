import 'package:fitness_tracker_app/view/total_workout_stats.dart';
import 'package:fitness_tracker_app/view/weekly_chart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_state.dart';
import '../model/workout_model.dart';
import 'package:intl/intl.dart';
import 'calories_progress.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Stats'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutsLoaded) {
            final workoutData = _aggregateWorkoutData(state.workouts);
            final dailyCalories = _aggregateDailyCalories(state.workouts);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Daily Workout Stats',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(workoutData.keys.elementAt(value.toInt()));
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _createBarGroups(workoutData),
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),
                  const Text(
                    'Calories Burn Progress',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: CaloriesProgressChart(dailyCalories: dailyCalories),
                  ),

                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) => BlocProvider.value(
                  //           value: BlocProvider.of<WorkoutBloc>(context),
                  //           child: const TotalWorkoutStats(),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   child: const Text('Total Workout Stats'),
                  // ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<WorkoutBloc>(context),
                        child: const TotalWorkoutStats(),
                      ),
                    ),
                  );
                },
                child: const Text('Total Workout Stats'),
              ),


              ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }

  Map<String, int> _aggregateWorkoutData(List<Workout> workouts) {
    final Map<String, int> data = {};
    final currentDate = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(currentDate);

    for (var workout in workouts) {
      final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
      if (workoutDate == today) {
        // Filter workouts for today
        if (data.containsKey(workout.type)) {
          data[workout.type] = data[workout.type]! + workout.duration;
        } else {
          data[workout.type] = workout.duration;
        }
      }
    }
    return data;
  }

  Map<String, int> _aggregateDailyCalories(List<Workout> workouts) {
    final Map<String, int> data = {};
    final currentDate = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(currentDate);

    for (var workout in workouts) {
      final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
      if (workoutDate == today) {
        // Filter workouts for today
        if (data.containsKey(today)) {
          data[today] = data[today]! + workout.calories;
        } else {
          data[today] = workout.calories;
        }
      }
    }
    return data;
  }

  List<BarChartGroupData> _createBarGroups(Map<String, int> data) {
    return data.entries.map((entry) {
      return BarChartGroupData(
        x: data.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blueGrey.shade700,
            width: 16,
          ),
        ],
      );
    }).toList();
  }
}
