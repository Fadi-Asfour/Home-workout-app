import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Home%20View%20Model/mobile_home_view_model.dart';
import 'package:home_workout_app/view_models/Workout_View_Model/finish_workout_view_model.dart';
import 'package:provider/provider.dart';

import '../../models/workout2_model.dart';

class FinishWorkoutView extends StatefulWidget {
  FinishWorkoutView({Key? key}) : super(key: key);

  @override
  State<FinishWorkoutView> createState() => _FinishWorkoutViewState();
}

class _FinishWorkoutViewState extends State<FinishWorkoutView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      setState(() {
        workout = args['workout'] as Workout2Model;
        totalTime = args['totalTime'] ?? 0;
        exercises = args['exercises'] ?? [];
      });

      Provider.of<FinishWorkoutViewModel>(context, listen: false)
          .setWorkoutSummary(
              lang: getLang(context),
              totalTime: args['totalTime'] ?? 0,
              exercises: args['exercises'] ?? [],
              workoutId: workout.id);

      Provider.of<MobileHomeViewModel>(context, listen: false)
          .getSummaryData(lang: getLang(context), context: context);
    });
  }

  List<int> exercises = [];
  int totalTime = 0;
  Workout2Model workout = Workout2Model();
  String reps = 'reps'.tr();
  String sec = 'sec'.tr();

  String exerString = 'Exercises played:'.tr();
  String time = 'Time:'.tr();
  String calories = 'Calories burnt:'.tr();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          workout.name,
          style: theme.textTheme.bodyMedium!.copyWith(color: blueColor),
        ).tr(),
      ),
      body: Consumer<FinishWorkoutViewModel>(
        builder: (context, summary, child) => summary.getisLoading
            ? Center(
                child: bigLoader(
                  color: orangeColor,
                ),
              )
            : RefreshIndicator(
                color: orangeColor,
                onRefresh: () async {
                  await Provider.of<FinishWorkoutViewModel>(context,
                          listen: false)
                      .setWorkoutSummary(
                          lang: getLang(context),
                          totalTime: totalTime,
                          exercises: exercises,
                          workoutId: workout.id);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 200, left: 25, right: 25),
                          child: Text(
                            summary.getWorkoutSummary.message,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      if (summary.getWorkoutSummary.calories.isNotEmpty &&
                          summary.getWorkoutSummary.exercises.isNotEmpty &&
                          summary.getWorkoutSummary.totalTime.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: Text(
                              'Summary:',
                              style: theme.textTheme.bodyMedium,
                            ).tr(),
                          ),
                        ),
                      if (summary.getWorkoutSummary.exercises.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            '$exerString ${summary.getWorkoutSummary.exercises}',
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: blueColor),
                          ),
                        ),
                      if (summary.getWorkoutSummary.totalTime.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            '$time ${summary.getWorkoutSummary.totalTime} $sec',
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: blueColor),
                          ),
                        ),
                      if (summary.getWorkoutSummary.calories.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            '$calories ${summary.getWorkoutSummary.calories}',
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: blueColor),
                          ),
                        )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
