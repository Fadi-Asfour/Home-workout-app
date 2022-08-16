import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/challenge_model.dart';
import 'package:home_workout_app/view_models/specific_challenge_view_model.dart';
import 'package:home_workout_app/views/Home%20View/home_view_widgets.dart';
import 'package:provider/provider.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter/foundation.dart' as foundation;

class SpecificChallenge extends StatefulWidget {
  const SpecificChallenge({Key? key}) : super(key: key);

  @override
  State<SpecificChallenge> createState() => _SpecificChallengeState();
}

class _SpecificChallengeState extends State<SpecificChallenge> {
  Duration countDownDuration = Duration(seconds: 50);
  Duration duration = Duration();
  Timer? timer;

  bool isCountdown = true;

  var argu;
  bool isSensor = false;

  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenSensor();

    Future.delayed(Duration.zero).then((value) async {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      setState(() {
        argu = args;
        isSensor = argu['sensor'];
      });

      Provider.of<SpeceficChallengeViewModel>(context, listen: false).reset();
      Provider.of<SpeceficChallengeViewModel>(context, listen: false).getData(
          context.locale == Locale('en') ? 'en' : 'ar', argu['id'], 'in');
      print('tapped');
      print(argu['id']);
      // countDownDuration = Duration(
      //     seconds:
      //         Provider.of<SpeceficChallengeViewModel>(context, listen: true)
      //             .challengeCount);
      setState(() {
        // int initalTime =
        //     Provider.of<SpeceficChallengeViewModel>(context, listen: false)
        //         .challengeCount;
        duration = Duration(seconds: argu['count'] ?? 3);
        print('ddddddddddddddfffffff');
        print(duration.inSeconds);
      });
      listenSensor();
    });

    // startTimer();
    reset();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      Provider.of<SpeceficChallengeViewModel>(context, listen: false)
          .setProximityVal(event > 0);
      setState(() {
        _isNear = (event > 0) ? true : false;
      });
    });
  }

  void reset() {
    if (isCountdown) {
      setState(() {
        duration = countDownDuration;
      });
    } else {
      setState(() {
        duration = Duration();
      });
    }
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() {
      timer?.cancel();
    });
  }

  void addTime() {
    final addSeconds = isCountdown ? -1 : 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      print(seconds);
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Container(
        height: 70,
        child: ElevatedButton(
          onPressed: () async {
            if (Provider.of<SpeceficChallengeViewModel>(context, listen: false)
                .challenge
                .is_time!) {
              Provider.of<SpeceficChallengeViewModel>(context, listen: false)
                  .setFinalCount(duration.inSeconds);
            } else if (argu['sensor']) {
              Provider.of<SpeceficChallengeViewModel>(context, listen: false)
                  .setFinalCount(Provider.of<SpeceficChallengeViewModel>(
                          context,
                          listen: false)
                      .proximityCount);
              print('object');
              print(Provider.of<SpeceficChallengeViewModel>(context,
                      listen: false)
                  .setFinalCount(Provider.of<SpeceficChallengeViewModel>(
                          context,
                          listen: false)
                      .FinalCount));
            } else {
              Provider.of<SpeceficChallengeViewModel>(context, listen: false)
                  .setFinalCount(Provider.of<SpeceficChallengeViewModel>(
                          context,
                          listen: false)
                      .FinalCount);
            }

            final ChallengeModel BackEndMessage =
                await Provider.of<SpeceficChallengeViewModel>(context,
                        listen: false)
                    .saveSpecificChallengeData(
                        Provider.of<SpeceficChallengeViewModel>(context,
                                listen: false)
                            .FinalCount,
                        getLang(context),
                        argu['id']);

            if (BackEndMessage.message != '' || BackEndMessage.message != '') {
              showSnackbar(Text(BackEndMessage.message.toString()), context);
            }
            if (BackEndMessage.statusCode == 200) {
              Navigator.of(context).pop();
              timer?.cancel();
            }
          },
          child: Text('Finish').tr(),
        ),
      ),
      appBar: AppBar(
          title: Text(
        'Challenge',
        style: theme.textTheme.bodyMedium!,
      ).tr()),
      body: Center(
        child: Container(
          // color: Colors.white,
          child: SingleChildScrollView(
            // controller: controller,
            child: Provider.of<SpeceficChallengeViewModel>(context,
                        listen: true)
                    .getisLoading
                ? bigLoader(color: orangeColor)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text('$_isNear'),
                      Container(
                        // width: mq.size.width * 0.3,
                        // height: mq.size.height * 0.2,

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress != null
                                    ? const LoadingContainer()
                                    : child,
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              // 'https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
                              "$ip/${Provider.of<SpeceficChallengeViewModel>(context).getchallenge.img}",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mq.size.height * 0.1,
                      ),
                      Provider.of<SpeceficChallengeViewModel>(context)
                                  .getchallenge
                                  .is_time ??
                              true
                          ? Column(
                              children: [
                                Container(
                                  child: buildTime(),
                                ),
                                buildButtons(),

                                // ElevatedButton(
                                //     onPressed: () {
                                //       print(duration.inMinutes);
                                //     },
                                //     child: Text('test'))
                              ],
                            )
                          : isSensor
                              ? Column(
                                  children: [
                                    buildTimeCard(
                                        time: (Provider.of<
                                                        SpeceficChallengeViewModel>(
                                                    context)
                                                .FinalCount)
                                            .toString(),
                                        header: 'Counts'.tr()),
                                    Provider.of<SpeceficChallengeViewModel>(
                                                    context)
                                                .FinalCount >=
                                            0
                                        ? Container()
                                        : Container(
                                            child:
                                                Text('Congratulations!').tr(),
                                          ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    buildTimeCard(
                                        time: Provider.of<
                                                    SpeceficChallengeViewModel>(
                                                context)
                                            .FinalCount
                                            .toString(),
                                        header: 'Counts'),
                                    Provider.of<SpeceficChallengeViewModel>(
                                                    context)
                                                .FinalCount >=
                                            0
                                        ? ElevatedButton(
                                            onPressed: () {
                                              Provider.of<SpeceficChallengeViewModel>(
                                                      context,
                                                      listen: false)
                                                  .decreaseFinalCount();
                                            },
                                            child: Icon(Icons.remove))
                                        : Container(
                                            child:
                                                Text('Congratulations!').tr(),
                                          ),
                                  ],
                                ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Description".tr() +
                            "${Provider.of<SpeceficChallengeViewModel>(context).challenge.desc.toString()}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Calories".tr() +
                            "${Provider.of<SpeceficChallengeViewModel>(context).challenge.calory.toString()}"),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ));
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'Hours'),
        SizedBox(
          width: 8,
        ),
        buildTimeCard(time: minutes, header: 'Minutes'),
        SizedBox(
          width: 8,
        ),
        buildTimeCard(time: seconds, header: 'Seconds'),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: blueColor, borderRadius: BorderRadius.circular(20)),
          child: Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: orangeColor,
              fontSize: 72,
              decoration: TextDecoration.none,
            ),
          ).tr(),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          header.tr(),
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: orangeColor,
            fontSize: 20,
            decoration: TextDecoration.none,
          ),
        ).tr(),
      ],
    );
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;

    return isRunning || !isCompleted
        ? ElevatedButton(
            onPressed: () {
              if (isRunning) {
                stopTimer(resets: false);
              } else {
                startTimer(resets: false);
              }
            },
            child: Text(isRunning ? 'Stop'.tr() : 'Start'.tr()))
        : Container(
            child: Text('Congratulations!').tr(),
          );
    // return isRuning ? ElevatedButton(onPressed: () {}, child: Text('Stop'));
  }
}
