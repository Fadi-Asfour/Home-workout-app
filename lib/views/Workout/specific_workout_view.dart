import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Workout_View_Model/specific_workout_view_model.dart';
import 'package:provider/provider.dart';

import '../../components.dart';
import '../../view_models/Diet View Model/Diet/specific_diet_view_model.dart';
import '../Home View/home_view_widgets.dart';

class SpecificWorkoutView extends StatefulWidget {
  const SpecificWorkoutView({Key? key}) : super(key: key);

  @override
  State<SpecificWorkoutView> createState() => _SpecificWorkoutViewState();
}

class _SpecificWorkoutViewState extends State<SpecificWorkoutView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;

      Provider.of<SpecificWorkoutViewModel>(context, listen: false).setWorkout(
        lang: getLang(context),
        id: args['workoutId'] ?? 0,
      );
    });
  }

  String mealString = 'Meals:'.tr();
  String kcalString = 'kcal'.tr();
  String dayString = 'Day'.tr();
  String eq = 'Equipment:'.tr();
  String reps = 'reps'.tr();
  String sec = 'sec'.tr();

  String predictedString = 'Predicted burnt calories:'.tr();
  String exer = 'Exercises:'.tr();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: Consumer<SpecificWorkoutViewModel>(
        builder: (context, value, child) => FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/practice',
                arguments: {'workout': value.getWorkout});
          },
          child: Text(
            'Start',
            style: theme.textTheme.bodySmall!.copyWith(color: Colors.white),
          ).tr(),
        ),
      ),
      appBar: AppBar(
        title: Consumer<SpecificWorkoutViewModel>(
          builder: (context, workout, child) => Row(
            children: [
              Text(
                workout.getWorkout.name,
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: blueColor, fontSize: 23),
              ).tr(),
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.electric_bolt_rounded,
                size: 25,
                color: workout.getWorkout.difficulty == 1
                    ? Colors.green
                    : (workout.getWorkout.difficulty == 2
                        ? Colors.yellow
                        : Colors.red),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<SpecificWorkoutViewModel>(
        builder: (context, workout, child) => workout.getIsLoading
            ? Center(
                child: bigLoader(color: orangeColor),
              )
            : RefreshIndicator(
                color: orangeColor,
                onRefresh: () async {
                  await Provider.of<SpecificWorkoutViewModel>(context,
                          listen: false)
                      .setWorkout(
                          lang: getLang(context), id: workout.getWorkout.id);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (BuildContext context) {
                            try {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  errorBuilder: (context, error, stackTrace) =>
                                      const LoadingContainer(),
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          loadingProgress != null
                                              ? const LoadingContainer()
                                              : child,
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage(workout.getWorkout.imgUrl),
                                ),
                              );
                            } catch (e) {
                              return const LoadingContainer();
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(workout.getWorkout.description,
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(color: greyColor, fontSize: 15)),
                          ),
                        ),
                        Divider(
                          indent: 50,
                          endIndent: 50,
                          color: blueColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '$predictedString ${workout.getWorkout.burnCalories} $kcalString',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: blueColor)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '$exer ${workout.getWorkout.exercisesCount}',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: blueColor)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '$eq ${workout.getWorkout.equipment.tr()}',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: blueColor)),
                        ),
                        Divider(
                          indent: 50,
                          endIndent: 50,
                          color: blueColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Exercises:',
                                  style: theme.textTheme.bodySmall!
                                      .copyWith(color: orangeColor))
                              .tr(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: ListBody(
                            children: workout.getWorkout.exercises
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: blueColor, width: 1),
                                      ),
                                      child: InkWell(
                                        child: ListTile(
                                          title: Text(
                                            e.name,
                                            style: theme.textTheme.bodySmall,
                                          ),
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(e.imgUrl),
                                          ),
                                          subtitle: Text(
                                            e.description,
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(
                                                    color: greyColor,
                                                    fontSize: 12),
                                          ),
                                          trailing: Text(
                                            e.count != 0
                                                ? '${e.count} $reps'
                                                : '${e.length} $sec',
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(color: blueColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
