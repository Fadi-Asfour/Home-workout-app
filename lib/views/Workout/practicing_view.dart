// ignore_for_file: curly_braces_in_flow_control_structures, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/workout2_model.dart';
import 'package:home_workout_app/view_models/Workout_View_Model/practicing_view_model.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../Home View/home_view_widgets.dart';

class PracticingView extends StatefulWidget {
  PracticingView({Key? key}) : super(key: key);

  @override
  State<PracticingView> createState() => _PracticingViewState();
}

class _PracticingViewState extends State<PracticingView> {
  static const countdownDuration = Duration(seconds: 1);
  Duration duration = const Duration(seconds: 0);
  Timer? timer;
  Timer? breakTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (timer != null) {
      log(timer!.isActive.toString());
      timer!.cancel();
    }
    timer = null;

    Future.delayed(Duration.zero).then((value) {
      breakTimer = Timer.periodic(countdownDuration, (timer) {
        if (Provider.of<PracticingViewModel>(context,
                        listen: false)
                    .getIsPlaying ==
                false &&
            Provider.of<PracticingViewModel>(context, listen: false)
                    .getIsSkipped ==
                false &&
            Provider.of<PracticingViewModel>(context, listen: false)
                    .getCurrentExerciseIndex >
                0) {
          log('Increasing ${Provider.of<PracticingViewModel>(context, listen: false).getIsPlaying}  ,  ${Provider.of<PracticingViewModel>(context, listen: false).getCurrentExerciseIndex}');
          Provider.of<PracticingViewModel>(context, listen: false)
              .setBreakSec(0);
        } else {
          Provider.of<PracticingViewModel>(context, listen: false)
              .addToTotlaSec(
                  Provider.of<PracticingViewModel>(context, listen: false)
                      .getBreakSec);
          log('Stopped');
          Provider.of<PracticingViewModel>(context, listen: false)
              .resetBreakSec();
        }
      });
      timer = null;

      final args = ModalRoute.of(context)!.settings.arguments as Map;
      setState(() {
        workout = args['workout'] as Workout2Model;
      });
      Provider.of<PracticingViewModel>(context, listen: false).reset();
      Provider.of<PracticingViewModel>(context, listen: false)
          .startPractice(lang: getLang(context), id: workout.id);
    });
    timer = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer != null) {
      log(timer!.isActive.toString());
      timer!.cancel();
    }
    timer = null;

    if (breakTimer != null) {
      log(breakTimer!.isActive.toString());
      breakTimer!.cancel();
    }
    breakTimer = null;
  }

  String reps = 'reps'.tr();
  String sec = 'sec'.tr();

  Workout2Model workout = Workout2Model();
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: workout.exercises.isEmpty
          ? null
          : Consumer<PracticingViewModel>(
              builder: (context, practice, child) => FloatingActionButton(
                onPressed: () {
                  //if (breakTimer != null) breakTimer!.cancel();
                  practice.setIsPlaying(false);
                  practice.setIsSKipped(true);
                  practice.addToTotlaSec(practice.getBreakSec);
                  practice.resetBreakSec();
                  practice.setIsPlaying(false);
                  if (timer != null) {
                    timer!.cancel();
                  }
                  practice.setTimer(0);

                  //timer = Timer.periodic(duration, (timer) {});
                  timer = null;
                  if (practice.getCurrentExerciseIndex + 1 <
                      workout.exercises.length) {
                    _pageController.animateTo(
                        practice.getCurrentExerciseIndex + 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear);
                    practice.setCurrentExerciseIndex(
                        practice.getCurrentExerciseIndex + 1);
                  } else {
                    log('Workout Finished , Total Seconds: ${practice.getTotalSeconds} , finished exercises: ${practice.getFinishedIds}');
                    Navigator.pushReplacementNamed(context, '/finishWorkout',
                        arguments: {
                          'workout': workout,
                          'totalTime': practice.getTotalSeconds,
                          'exercises': practice.getFinishedIds
                        });
                  }
                },
                child: const Text('Skip').tr(),
              ),
            ),
      bottomNavigationBar: Consumer<PracticingViewModel>(
          builder: (context, practice, child) => workout.exercises.isEmpty ||
                  (workout.exercises.isNotEmpty &&
                      workout.exercises[practice.getCurrentExerciseIndex]
                              .length !=
                          0 &&
                      practice.getIsPlaying)
              ? const Text('')
              : TextButton(
                  onPressed: () {
                    practice.setIsSKipped(false);

                    if (timer != null) {
                      timer!.cancel();
                    }
                    timer = null;

                    if (practice.getIsPlaying == false) {
                      if (workout.exercises[practice.getCurrentExerciseIndex]
                              .count !=
                          0) {
                        practice.setIs1Break(false);

                        practice.addToTotlaSec(practice.getBreakSec);
                        practice.resetBreakSec();

                        ///stop break
                        if (timer != null) {
                          timer!.cancel();
                        }
                        timer = null;

                        // timer!.cancel();
                        // //practice.setTimer(0);
                        // timer = Timer.periodic(duration, (timer) {});

                        //
                        practice.setIsPlaying(true);
                        timer = Timer.periodic(countdownDuration, (timer) {
                          practice.setTimer(timer.tick);
                        });
                      } else if (workout
                              .exercises[practice.getCurrentExerciseIndex]
                              .length !=
                          0) {
                        practice.setIs1Break(false);

                        practice.addToTotlaSec(practice.getBreakSec);
                        practice.resetBreakSec();

                        ///stop break
                        ///

                        if (timer != null) {
                          timer!.cancel();
                        }

                        //practice.setTimer(0);
                        //timer = Timer.periodic(duration, (timer) {});
                        timer = null;

                        //
                        practice.setIsPlaying(true);
                        timer = Timer.periodic(countdownDuration, (timer) {
                          if (timer.tick <=
                              workout
                                  .exercises[practice.getCurrentExerciseIndex]
                                  .length) {
                            practice.setTimer(timer.tick);
                          } else {
                            practice.setIs1Break(true);

                            practice.setIsPlaying(false);
                            practice.addToTotlaSec(practice.getTimer);
                            timer.cancel();
                            practice.setTimer(0);
                            timer = Timer.periodic(duration, (timer) {});

                            if (practice.getCurrentExerciseIndex + 1 <
                                workout.exercises.length) {
                              practice.addToFinishedIDs(workout
                                  .exercises[practice.getCurrentExerciseIndex]
                                  .id);
                              if (timer != null) {
                                timer.cancel();
                              }

                              _pageController.animateTo(
                                  practice.getCurrentExerciseIndex + 1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear);
                              practice.setCurrentExerciseIndex(
                                  practice.getCurrentExerciseIndex + 1);
                            } else {
                              practice.setIs2Break(false);

                              practice.addToTotlaSec(practice.getBreakSec);
                              practice.resetBreakSec();

                              ///stop break
                              ///
                              if (timer != null) {
                                timer.cancel();
                              }

                              //practice.setTimer(0);
                              timer = Timer.periodic(duration, (timer) {});

                              practice.addToFinishedIDs(workout
                                  .exercises[practice.getCurrentExerciseIndex]
                                  .id);
                              log('Workout Finished , Total Seconds: ${practice.getTotalSeconds} , finished exercises: ${practice.getFinishedIds}');
                              Navigator.pushReplacementNamed(
                                  context, '/finishWorkout',
                                  arguments: {
                                    'workout': workout,
                                    'totalTime': practice.getTotalSeconds,
                                    'exercises': practice.getFinishedIds
                                  });
                            }
                          }
                        });
                      }
                    } else {
                      if (workout.exercises[practice.getCurrentExerciseIndex]
                              .count !=
                          0) {
                        practice.setIs2Break(true);

                        practice.setIsPlaying(false);
                        practice.addToTotlaSec(practice.getTimer);
                        if (timer != null) {
                          timer!.cancel();
                        }
                        practice.setTimer(0);
                        //timer = Timer.periodic(duration, (timer) {});
                        timer = null;

                        if (practice.getCurrentExerciseIndex + 1 <
                            workout.exercises.length) {
                          practice.addToFinishedIDs(workout
                              .exercises[practice.getCurrentExerciseIndex].id);
                          if (timer != null) {
                            timer!.cancel();
                          }
                          timer = Timer(duration, () {});

                          _pageController.animateTo(
                              practice.getCurrentExerciseIndex + 1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.linear);
                          practice.setCurrentExerciseIndex(
                              practice.getCurrentExerciseIndex + 1);
                        } else {
                          ///stop break
                          ///

                          if (timer != null) {
                            timer!.cancel();
                          }
                          //practice.setTimer(0);
                          //timer = Timer.periodic(duration, (timer) {});
                          timer = null;

                          practice.addToFinishedIDs(workout
                              .exercises[practice.getCurrentExerciseIndex].id);

                          log('Workout Finished , Total Seconds: ${practice.getTotalSeconds} , finished exercises: ${practice.getFinishedIds}');
                          Navigator.pushReplacementNamed(
                              context, '/finishWorkout',
                              arguments: {
                                'workout': workout,
                                'totalTime': practice.getTotalSeconds,
                                'exercises': practice.getFinishedIds
                              });
                          return;
                        }
                      }
                    }
                  },
                  child: Text(
                    practice.getIsPlaying ? 'Finish'.tr() : 'Start'.tr(),
                    style: theme.textTheme.bodyMedium,
                  ),
                )),
      appBar: AppBar(
        title: Consumer<PracticingViewModel>(
          builder: (context, practice, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                workout.exercises.isNotEmpty
                    ? workout.exercises[practice.getCurrentExerciseIndex].name
                    : '0',
                style: theme.textTheme.bodyMedium!.copyWith(color: blueColor),
              ).tr(),
              if (practice.getBreakSec != 0)
                Text(
                  'Break'.tr() +
                      ' ' +
                      practice.getBreakSec.toString() +
                      ' ' +
                      'sec'.tr(),
                  style: theme.textTheme.bodySmall!.copyWith(color: blueColor),
                ).tr(),
            ],
          ),
        ),
      ),
      body: Consumer<PracticingViewModel>(
        builder: (context, practice, child) => (practice.getIsLoading ||
                workout.exercises.isEmpty)
            ? Center(
                child: bigLoader(color: orangeColor),
              )
            : PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Column(
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        try {
                          return Image(
                            errorBuilder: (context, error, stackTrace) =>
                                const LoadingContainer(),
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress != null
                                    ? const LoadingContainer()
                                    : child,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            image: NetworkImage(workout
                                .exercises[practice.getCurrentExerciseIndex]
                                .imgUrl),
                          );
                        } catch (e) {
                          return const LoadingContainer();
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        workout.exercises[practice.getCurrentExerciseIndex]
                            .description,
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: greyColor),
                      ),
                    ),
                    Divider(
                      indent: 50,
                      endIndent: 50,
                      color: blueColor,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(workout
                                    .exercises[practice.getCurrentExerciseIndex]
                                    .length !=
                                0
                            ? '${workout.exercises[practice.getCurrentExerciseIndex].length} $sec'
                            : '${workout.exercises[practice.getCurrentExerciseIndex].count} $reps'),
                      ),
                    ),
                    // if (practice.getTimer != 0)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: mq.size.width * 0.25),
                      child: Column(
                        children: [
                          Text(
                            'Timer',
                            style: theme.textTheme.bodyMedium,
                          ).tr(),
                          Text('${practice.getTimer} $sec',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: greyColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
