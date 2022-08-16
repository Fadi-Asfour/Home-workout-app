// ignore_for_file: curly_braces_in_flow_control_structures, must_be_immutable

import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/user_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:home_workout_app/views/Home%20View/home_view_widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class webProfilePage extends StatefulWidget {
  webProfilePage(
      {
      // required this.user,
      Key? key})
      : super(key: key);

  //UserModel user;

  @override
  State<webProfilePage> createState() => _webProfilePageState();
}

class _webProfilePageState extends State<webProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProfileViewModel>(context, listen: false)
        .setCurrentUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: AnimatedOpacity(
            opacity: Provider.of<ProfileViewModel>(context, listen: true)
                    .getInfoWidgetVisible
                ? 1
                : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              //height: user.getInfoWidgetVisible ? 100 : 0,
              child: Consumer<ProfileViewModel>(
                builder: (context, user, child) => Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.getUserData.imageUrl),
                      onBackgroundImageError: (child, stacktrace) =>
                          const LoadingContainer(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: user.getUserData.role == 'Manager'
                                  ? Colors.red.shade900
                                  : (user.getUserData.role == 'Coach'
                                      ? blueColor
                                      : orangeColor),
                              width: 2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '${user.getUserData.fname} ${user.getUserData.lname}',
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Consumer<ProfileViewModel>(
                    builder: (context, user, child) => VisibilityDetector(
                      key: Key(user.getUserData.id.toString()),
                      onVisibilityChanged: (VisibilityInfo info) {
                        if (info.visibleBounds.isEmpty)
                          user.setInfoWidgetVisible(true);
                        else
                          user.setInfoWidgetVisible(false);
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage(user.getUserData.imageUrl),
                        onBackgroundImageError: (child, stacktrace) =>
                            const LoadingContainer(),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: user.getUserData.role == 'Manager'
                                    ? Colors.red.shade900
                                    : (user.getUserData.role == 'Coach'
                                        ? blueColor
                                        : orangeColor),
                                width: 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<ProfileViewModel>(
                  builder: (context, user, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${user.getUserData.fname} ${user.getUserData.lname}',
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        ' ( ${user.getUserData.role.toUpperCase()} )',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 15,
                          color: user.getUserData.role == 'Manager'
                              ? Colors.red.shade900
                              : (user.getUserData.role == 'Coach'
                                  ? blueColor
                                  : orangeColor),
                        ),
                      ),
                    ],
                  ),
                ),
                if (Provider.of<ProfileViewModel>(context, listen: false)
                            .getUserData
                            .id !=
                        '1' &&
                    Provider.of<ProfileViewModel>(context, listen: false)
                            .getUserData
                            .role ==
                        'coach')
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      ' + Follow',
                      style: theme.textTheme.bodySmall!.copyWith(
                          color: blueColor, fontWeight: FontWeight.w400),
                    ),
                  ),
                if (Provider.of<ProfileViewModel>(context, listen: false)
                            .getUserData
                            .role ==
                        'coach' ||
                    Provider.of<ProfileViewModel>(context, listen: false)
                            .getUserData
                            .role ==
                        'dietitian')
                  ExpansionTile(
                    iconColor: blueColor,
                    title: Text(
                      'Shared workouts',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                if (Provider.of<ProfileViewModel>(context, listen: false)
                            .getUserData
                            .role ==
                        'coach' ||
                    Provider.of<ProfileViewModel>(context, listen: false)
                            .getUserData
                            .role ==
                        'dietitian')
                  ExpansionTile(
                    iconColor: blueColor,
                    title: Text(
                      'Shared posts',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer<ProfileViewModel>(
                      builder: (context, user, child) =>
                          CircularPercentIndicator(
                        radius: 50,
                        animation: true,
                        center: Text(
                          'Finished Workouts \n ${user.getUserData.finishedWorkouts}/${user.getUserData.enteredWorkouts}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall!
                              .copyWith(fontSize: 10, color: blueColor),
                        ),
                        progressColor: blueColor,
                        percent: user.getUserData.finishedWorkouts /
                            user.getUserData.enteredWorkouts,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
