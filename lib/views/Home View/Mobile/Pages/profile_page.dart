// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/workout_list_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:home_workout_app/views/Home%20View/Mobile/mobile_home_view_widgets.dart';
import 'package:home_workout_app/views/Home%20View/home_view_widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../view_models/Diet View Model/Diet/diet_list_view_model.dart';
import '../../../Posts View/post_view_widgets.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ScrollController _scrollController = ScrollController();
  String exer = 'Exercises:'.tr();
  String min = 'min'.tr();
  String kcal = 'Kcal'.tr();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Provider.of<ProfileViewModel>(context, listen: false).setCurrentUserData();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<ProfileViewModel>(context, listen: false)
          .setInfoWidgetVisible(false);
      Provider.of<ProfileViewModel>(context, listen: false)
          .setHealthRecord(context.locale == Locale('en') ? 'en' : 'ar');

      _scrollController.addListener(() {
        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            Provider.of<ProfileViewModel>(context, listen: false)
                .getPostIsOpened) {
          Provider.of<ProfileViewModel>(context, listen: false)
              .setUserPosts(context.locale == const Locale('en') ? 'en' : 'ar');
        }

        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            Provider.of<ProfileViewModel>(context, listen: false)
                .getDietIsOpened) {
          Provider.of<ProfileViewModel>(context, listen: false)
              .setUserDiets(context.locale == const Locale('en') ? 'en' : 'ar');
        }

        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            Provider.of<ProfileViewModel>(context, listen: false)
                .getWorkoutIsOpened) {
          Provider.of<ProfileViewModel>(context, listen: false).setUserWorkouts(
              lang: context.locale == const Locale('en') ? 'en' : 'ar',
              userId: Provider.of<ProfileViewModel>(context, listen: false)
                  .getUserData
                  .id);
        }
      });
    });
  }

  String finishedWorkouts = 'Finished Workouts'.tr();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Provider.of<ProfileViewModel>(context, listen: true).getIsLoading
        ? const CustomLoading()
        : RefreshIndicator(
            color: orangeColor,
            onRefresh: () async {
              Provider.of<ProfileViewModel>(context, listen: false).setPage(0);
              Provider.of<ProfileViewModel>(context, listen: false)
                  .clearPosts();
              await Provider.of<ProfileViewModel>(context, listen: false)
                  .setCurrentUserData(context);
              await Provider.of<ProfileViewModel>(context, listen: false)
                  .setHealthRecord(
                      context.locale == const Locale('en') ? 'en' : 'ar');
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: AnimatedOpacity(
                    opacity:
                        Provider.of<ProfileViewModel>(context, listen: true)
                                .getInfoWidgetVisible
                            ? 1
                            : 0,
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedContainer(
                      color: Colors.transparent,
                      duration: const Duration(milliseconds: 300),
                      //height: user.getInfoWidgetVisible ? 100 : 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Consumer<ProfileViewModel>(
                                builder: (context, user, child) => CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(user.getUserData.imageUrl),
                                  onBackgroundImageError: (child, stacktrace) =>
                                      const LoadingContainer(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: user.getUserData.roleId == 2
                                              ? orangeColor
                                              : (user.getUserData.roleId == 3
                                                  ? blueColor
                                                  : Colors.transparent),
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Consumer<ProfileViewModel>(
                                  builder: (context, user, child) => Text(
                                    '${user.getUserData.fname} ${user.getUserData.lname}',
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (Provider.of<ProfileViewModel>(context,
                                  listen: true)
                              .getMoreLoading)
                            bigLoader(color: orangeColor)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: _scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Consumer<ProfileViewModel>(
                            builder: (context, user, child) =>
                                VisibilityDetector(
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
                                        color: user.getUserData.roleId == 2
                                            ? orangeColor
                                            : (user.getUserData.roleId == 3
                                                ? blueColor
                                                : Colors.transparent),
                                        width: 2),
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
                              if (user.getUserData.roleId == 2 ||
                                  user.getUserData.roleId == 3)
                                Text(
                                  ' ( ${user.getUserData.role.toUpperCase()} )',
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 15,
                                    color: user.getUserData.roleId == 2
                                        ? orangeColor
                                        : (user.getUserData.roleId == 3
                                            ? blueColor
                                            : Colors.transparent),
                                  ),
                                ),
                              Align(
                                alignment: context.locale == const Locale('en')
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Consumer<ProfileViewModel>(
                                  builder: (context, user, child) =>
                                      user.getIsRemoveLoading
                                          ? smallLoader(color: orangeColor)
                                          : PopupMenuButton<String>(
                                              icon: Icon(
                                                Icons.more_vert_rounded,
                                                color: blueColor,
                                              ),
                                              onSelected:
                                                  (String result) async {
                                                switch (result) {
                                                  case 'edit':
                                                    Navigator.pushNamed(
                                                        context, '/editProfile',
                                                        arguments: {
                                                          'userData': Provider
                                                                  .of<ProfileViewModel>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .getUserData
                                                        });
                                                    break;
                                                  case 'delete':
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    ctx) =>
                                                                AlertDialog(
                                                                  title: Text(
                                                                    'Are you sure to delete your account ?',
                                                                    style: theme
                                                                        .textTheme
                                                                        .bodySmall,
                                                                  ).tr(),
                                                                  content:
                                                                      SizedBox(
                                                                    height: sharedPreferences.getBool('googleProvider') ==
                                                                            true
                                                                        ? 25
                                                                        : 75,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          'Note: You can reactive your account in 30 days.',
                                                                          style: theme
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: greyColor, fontSize: 12),
                                                                        ).tr(),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        if (sharedPreferences.getBool('googleProvider') ==
                                                                            false)
                                                                          TextField(
                                                                            obscureText:
                                                                                true,
                                                                            controller:
                                                                                passwordController,
                                                                            keyboardType:
                                                                                TextInputType.visiblePassword,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              label: FittedBox(child: const Text('Password').tr()),
                                                                              floatingLabelStyle: theme.textTheme.bodySmall,
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: orangeColor, width: 1.5),
                                                                                borderRadius: const BorderRadius.all(
                                                                                  Radius.circular(15),
                                                                                ),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: greyColor, width: 1.5),
                                                                                borderRadius: const BorderRadius.all(
                                                                                  Radius.circular(15),
                                                                                ),
                                                                              ),
                                                                              errorBorder: const OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.red, width: 1.5),
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(15),
                                                                                ),
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: orangeColor, width: 1.5),
                                                                                borderRadius: const BorderRadius.all(
                                                                                  Radius.circular(15),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await user.deleteAccount(
                                                                            passwordController.text
                                                                                .trim(),
                                                                            context.locale == const Locale('en')
                                                                                ? 'en'
                                                                                : 'ar',
                                                                            context);
                                                                        passwordController
                                                                            .clear();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Yes',
                                                                        style: theme
                                                                            .textTheme
                                                                            .bodySmall,
                                                                      ).tr(),
                                                                    ),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              ctx);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style: theme
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: blueColor),
                                                                        ).tr())
                                                                  ],
                                                                ));
                                                    break;
                                                  case 'blocklist':
                                                    await user.setBlocklist(
                                                        context.locale ==
                                                                Locale('en')
                                                            ? 'en'
                                                            : 'ar');
                                                    showBottomList(
                                                        context,
                                                        'Blocklist',
                                                        user.getBlocklist);

                                                    break;

                                                  case 'apply':
                                                    Navigator.pushNamed(
                                                        context, '/apply');
                                                    break;
                                                  case 'editApply':
                                                    Navigator.pushNamed(
                                                        context, '/cv');
                                                    break;

                                                  case 'removeRole':
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    ctx) =>
                                                                AlertDialog(
                                                                  title: Column(
                                                                    children: [
                                                                      Text(
                                                                        'Are you sure to remove your role ?',
                                                                        style: theme
                                                                            .textTheme
                                                                            .bodySmall,
                                                                      ).tr(),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      if (sharedPreferences
                                                                              .getBool('googleProvider') ==
                                                                          false)
                                                                        TextField(
                                                                          obscureText:
                                                                              true,
                                                                          controller:
                                                                              passwordController,
                                                                          keyboardType:
                                                                              TextInputType.visiblePassword,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            label:
                                                                                FittedBox(child: const Text('Password').tr()),
                                                                            floatingLabelStyle:
                                                                                theme.textTheme.bodySmall,
                                                                            focusedErrorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(color: orangeColor, width: 1.5),
                                                                              borderRadius: const BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(color: greyColor, width: 1.5),
                                                                              borderRadius: const BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                            errorBorder:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.red, width: 1.5),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(color: orangeColor, width: 1.5),
                                                                              borderRadius: const BorderRadius.all(
                                                                                Radius.circular(15),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                    ],
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            ctx);
                                                                        await Provider.of<ProfileViewModel>(context, listen: false).removeRole(
                                                                            password:
                                                                                passwordController.text.trim(),
                                                                            lang: getLang(context),
                                                                            context: context);
                                                                        passwordController
                                                                            .clear();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Yes',
                                                                        style: theme
                                                                            .textTheme
                                                                            .bodySmall,
                                                                      ).tr(),
                                                                    ),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              ctx);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style: theme
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(color: blueColor),
                                                                        ).tr())
                                                                  ],
                                                                ));

                                                    break;
                                                  default:
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuEntry<String>>[
                                                PopupMenuItem<String>(
                                                  value: 'edit',
                                                  child: Text(
                                                    'Edit profile',
                                                    style: theme
                                                        .textTheme.bodySmall!
                                                        .copyWith(
                                                            color: blueColor),
                                                  ).tr(),
                                                ),
                                                if (user.getUserData.roleId !=
                                                    1)
                                                  PopupMenuItem<String>(
                                                    value: 'blocklist',
                                                    child: Text(
                                                      'Blocklist',
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color: blueColor),
                                                    ).tr(),
                                                  ),
                                                if (user.getUserData.roleId ==
                                                        1 &&
                                                    user.getUserData.cv ==
                                                        false)
                                                  PopupMenuItem<String>(
                                                    value: 'apply',
                                                    child: Text(
                                                      'Apply to be coach or dietitian',
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color: blueColor),
                                                    ).tr(),
                                                  ),
                                                if (user.getUserData.cv ==
                                                        true &&
                                                    user.getUserData.roleId !=
                                                        4 &&
                                                    user.getUserData.roleId !=
                                                        5)
                                                  PopupMenuItem<String>(
                                                    value: 'editApply',
                                                    child: Text(
                                                      'CV',
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color: blueColor),
                                                    ).tr(),
                                                  ),
                                                if (user.getUserData.roleId ==
                                                        2 ||
                                                    user.getUserData.roleId ==
                                                        3)
                                                  PopupMenuItem<String>(
                                                    value: 'removeRole',
                                                    child: Text(
                                                      'Remove Role',
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.red),
                                                    ).tr(),
                                                  ),
                                                PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: Text(
                                                    'Delete account',
                                                    style: theme
                                                        .textTheme.bodySmall!
                                                        .copyWith(
                                                            color: Colors.red),
                                                  ).tr(),
                                                ),
                                              ],
                                            ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<ProfileViewModel>(
                          builder: (context, user, child) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (user.getUserData.roleId == 2 ||
                                  user.getUserData.roleId == 3)
                                TextButton(
                                  onPressed: () async {
                                    await user.setFollowers(
                                        user.getUserData.id,
                                        context.locale == Locale('en')
                                            ? 'en'
                                            : 'ar');
                                    showBottomList(context, 'Followers',
                                        user.getFollowers);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Followers',
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: blueColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                      ).tr(),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        user.getUserData.followers.toString(),
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: greyColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              TextButton(
                                onPressed: () async {
                                  await user.setFollowings(
                                      user.getUserData.id,
                                      context.locale == Locale('en')
                                          ? 'en'
                                          : 'ar');

                                  showBottomList(context, 'Followings',
                                      user.getFollowings);
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      'Followings',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              color: blueColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                    ).tr(),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      user.getUserData.followings.toString(),
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              color: greyColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: context.locale == Locale('en')
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            child: Text(
                              'Bio',
                              style: theme.textTheme.bodySmall,
                            ).tr(),
                          ),
                        ),
                        Consumer<ProfileViewModel>(
                          builder: (context, user, child) => user
                                      .getUserData.bio ==
                                  ''
                              ? Text(
                                  'Tell others something about you!',
                                  style: theme.textTheme.bodySmall!
                                      .copyWith(color: greyColor, fontSize: 15),
                                ).tr()
                              : Container(
                                  width: mq.size.width * 0.95,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: blueColor),
                                  ),
                                  child: Text(
                                    user.getUserData.bio,
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                        // if (Provider.of<ProfileViewModel>(context, listen: true)
                        //         .getUserData
                        //         .roleId ==
                        //     2)
                        //   ExpansionTile(
                        //     iconColor: blueColor,
                        //     title: Text(
                        //       'Shared workouts',
                        //       style: theme.textTheme.bodySmall,
                        //     ).tr(),
                        //   ),
                        if (Provider.of<ProfileViewModel>(context,
                                        listen: true)
                                    .getUserData
                                    .roleId ==
                                2 ||
                            Provider.of<ProfileViewModel>(context, listen: true)
                                    .getUserData
                                    .roleId ==
                                4 ||
                            Provider.of<ProfileViewModel>(context, listen: true)
                                    .getUserData
                                    .roleId ==
                                5)
                          Consumer<ProfileViewModel>(
                            builder: (context, user, child) => ExpansionTile(
                              onExpansionChanged: (change) async {
                                if (change) {
                                  user.setWorkoutIsOpened(true);
                                  user.setWorkoutPage(0);
                                  user.clearWorkouts();
                                  await user.setUserWorkouts(
                                      lang: getLang(context),
                                      userId: user.getUserData.id);
                                } else {
                                  user.setWorkoutIsOpened(false);

                                  user.clearWorkouts();
                                }
                              },
                              iconColor: blueColor,
                              title: Text(
                                'Shared workouts',
                                style: theme.textTheme.bodySmall,
                              ).tr(),
                              children: (user.getIsWorkoutLogoutLoading &&
                                      user.getUserWorkouts.isEmpty)
                                  ? [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child:
                                                bigLoader(color: orangeColor)),
                                      ),
                                    ]
                                  : user.getUserWorkouts
                                      .map(
                                        (e) => _buildWorkoutList(context, 1, e),
                                      )
                                      .toList(),
                            ),
                          ),
                        if (Provider.of<ProfileViewModel>(context,
                                        listen: true)
                                    .getUserData
                                    .roleId ==
                                3 ||
                            Provider.of<ProfileViewModel>(context, listen: true)
                                    .getUserData
                                    .roleId ==
                                4 ||
                            Provider.of<ProfileViewModel>(context, listen: true)
                                    .getUserData
                                    .roleId ==
                                5)
                          Consumer<ProfileViewModel>(
                            builder: (context, user, child) => ExpansionTile(
                              onExpansionChanged: (change) async {
                                if (change) {
                                  user.setDietIsOpened(true);
                                  user.setDietPage(0);
                                  user.clearDiets();
                                  await user.setUserDiets(
                                      context.locale == Locale('en')
                                          ? 'en'
                                          : 'ar');
                                } else {
                                  user.setDietIsOpened(false);

                                  user.clearDiets();
                                }
                              },
                              iconColor: blueColor,
                              title: Text(
                                'Shared diets',
                                style: theme.textTheme.bodySmall,
                              ).tr(),
                              children: (user.getIsDietLogoutLoading &&
                                      user.getUserDiets.isEmpty)
                                  ? [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child:
                                                bigLoader(color: orangeColor)),
                                      ),
                                    ]
                                  : user.getUserDiets
                                      .map(
                                        (e) => InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/specDiet',
                                                arguments: {'dietId': e.id});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: blueColor,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    trailing: PopupMenuButton(
                                                      onSelected:
                                                          (value) async {
                                                        switch (value) {
                                                          case 'edit':
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/editDiet',
                                                                arguments: {
                                                                  'dietId':
                                                                      e.id,
                                                                  'diet': e
                                                                });
                                                            break;

                                                          case 'save':
                                                            final response = await Provider
                                                                    .of<
                                                                            DietListViewModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                .saveDiet(
                                                                    lang: getLang(
                                                                        context),
                                                                    id: e.id,
                                                                    context:
                                                                        context);
                                                            if (response) {
                                                              setState(() {
                                                                e.saved =
                                                                    !e.saved;
                                                              });
                                                            }
                                                            break;

                                                          case 'delete':
                                                            await Provider.of<
                                                                        ProfileViewModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deleteDiet(
                                                                    lang: getLang(
                                                                        context),
                                                                    id: e.id,
                                                                    context:
                                                                        context);
                                                            break;
                                                          default:
                                                        }
                                                      },
                                                      itemBuilder: (context) =>
                                                          [
                                                        PopupMenuItem(
                                                            value: 'save',
                                                            child: Text(
                                                              e.saved
                                                                  ? 'Saved'
                                                                  : 'Save',
                                                              style: theme
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                      color: e.saved
                                                                          ? Colors
                                                                              .amber
                                                                          : blueColor),
                                                            ).tr()),
                                                        if (Provider.of<ProfileViewModel>(context, listen: false).getUserData.roleId == 4 ||
                                                            Provider.of<ProfileViewModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getUserData
                                                                    .roleId ==
                                                                5 ||
                                                            Provider.of<ProfileViewModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getUserData
                                                                    .id ==
                                                                e.userId)
                                                          PopupMenuItem(
                                                              value: 'edit',
                                                              child: Text(
                                                                'Edit',
                                                                style: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        color:
                                                                            blueColor),
                                                              ).tr()),
                                                        if (Provider.of<ProfileViewModel>(context, listen: false).getUserData.roleId == 4 ||
                                                            Provider.of<ProfileViewModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getUserData
                                                                    .roleId ==
                                                                5 ||
                                                            Provider.of<ProfileViewModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getUserData
                                                                    .id ==
                                                                e.userId)
                                                          PopupMenuItem(
                                                              value: 'delete',
                                                              child: Text(
                                                                'Delete',
                                                                style: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .red),
                                                              ).tr())
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25,
                                                        vertical: 10),
                                                    child: Text(
                                                      e.name,
                                                      style: theme
                                                          .textTheme.bodyMedium,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25,
                                                        vertical: 10),
                                                    child: Row(
                                                      children: [
                                                        Text('Meals: ',
                                                                style: theme
                                                                    .textTheme
                                                                    .bodySmall)
                                                            .tr(),
                                                        Text(
                                                          e.mealsCount
                                                              .toString(),
                                                          style: theme.textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  color:
                                                                      greyColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    endIndent: 50,
                                                    indent: 50,
                                                    color: blueColor,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      25,
                                                                  vertical: 10),
                                                              child:
                                                                  RatingBarIndicator(
                                                                rating:
                                                                    e.rating,
                                                                itemSize: 25,
                                                                itemCount: 5,
                                                                itemBuilder: (context,
                                                                        index) =>
                                                                    const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                              )),
                                                          Text(
                                                            e.rating.toString(),
                                                            style: theme
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                    color:
                                                                        greyColor),
                                                          ),
                                                        ],
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/comments',
                                                              arguments: {
                                                                'id': e.id,
                                                                'review': true
                                                              });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'Comments',
                                                              style: theme
                                                                  .textTheme
                                                                  .bodySmall,
                                                            ).tr(),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios_rounded,
                                                              size: 15,
                                                              color:
                                                                  orangeColor,
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        if (Provider.of<ProfileViewModel>(context, listen: true)
                                .getUserData
                                .roleId !=
                            1)
                          Consumer<ProfileViewModel>(
                            builder: (context, user, child) => ExpansionTile(
                              onExpansionChanged: (change) async {
                                if (change) {
                                  user.setPostIsOpened(true);
                                  user.setPage(0);
                                  user.clearPosts();
                                  await user.setUserPosts(
                                      context.locale == Locale('en')
                                          ? 'en'
                                          : 'ar');
                                } else {
                                  user.setPostIsOpened(false);

                                  user.clearPosts();
                                }
                              },
                              iconColor: blueColor,
                              title: Text(
                                'Shared posts',
                                style: theme.textTheme.bodySmall,
                              ).tr(),
                              children: (user.getIsPostLogoutLoading &&
                                      user.getUserPosts.isEmpty)
                                  ? [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child:
                                                bigLoader(color: orangeColor)),
                                      ),
                                    ]
                                  : user.getUserPosts.map((e) {
                                      if (e.type == 2 || e.type == 3)
                                        return pollPostCard(
                                            post: e, ctx: context);
                                      else
                                        return NormalPostCard(
                                            post: e, ctx: context);
                                    }).toList(),
                            ),
                          ),
                        // ExpansionTile(
                        //   iconColor: blueColor,
                        //   title: Text(
                        //     'Statistics',
                        //     style: theme.textTheme.bodySmall,
                        //   ).tr(),
                        //   children: [
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //         Consumer<ProfileViewModel>(
                        //           builder: (context, user, child) =>
                        //               CircularPercentIndicator(
                        //             radius: 50,
                        //             animation: true,
                        //             center: Text(
                        //               '$finishedWorkouts \n ${user.getUserData.finishedWorkouts}/${user.getUserData.enteredWorkouts}',
                        //               textAlign: TextAlign.center,
                        //               style: theme.textTheme.bodySmall!
                        //                   .copyWith(
                        //                       fontSize: 10, color: blueColor),
                        //             ),
                        //             progressColor: blueColor,
                        //             percent: user.getUserData.finishedWorkouts /
                        //                 user.getUserData.enteredWorkouts,
                        //           ),
                        //         ),
                        //       ],
                        //     )
                        //   ],
                        // ),
                        ExpansionTile(
                          iconColor: blueColor,
                          title: Text(
                            'Health record',
                            style: theme.textTheme.bodySmall,
                          ).tr(),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (Provider.of<ProfileViewModel>(context,
                                            listen: true)
                                        .getHealthRecord
                                        .desc
                                        .isNotEmpty ||
                                    Provider.of<ProfileViewModel>(context,
                                            listen: true)
                                        .getHealthRecord
                                        .diseases
                                        .isNotEmpty)
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/editHealthRecord');
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 15,
                                    ),
                                  ),
                                if (Provider.of<ProfileViewModel>(context,
                                            listen: true)
                                        .getHealthRecord
                                        .desc
                                        .isNotEmpty ||
                                    Provider.of<ProfileViewModel>(context,
                                            listen: true)
                                        .getHealthRecord
                                        .diseases
                                        .isNotEmpty)
                                  Consumer<ProfileViewModel>(
                                    builder: (context, user, child) => user
                                            .getIseditLoading
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: smallLoader(
                                              color: Colors.red,
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () async {
                                              await Provider.of<
                                                          ProfileViewModel>(
                                                      context,
                                                      listen: false)
                                                  .deleteHealthRecord(
                                                      context.locale ==
                                                              const Locale('en')
                                                          ? 'en'
                                                          : 'ar',
                                                      context);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 15,
                                            ),
                                          ),
                                  )
                              ],
                            ),
                            if (Provider.of<ProfileViewModel>(context,
                                        listen: true)
                                    .getHealthRecord
                                    .desc
                                    .isEmpty &&
                                Provider.of<ProfileViewModel>(context,
                                        listen: true)
                                    .getHealthRecord
                                    .diseases
                                    .isEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "You don't have an health record ",
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        color: greyColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300),
                                  ).tr(),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/addHealthRecord');
                                      },
                                      child: Text(
                                        'add now +',
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: orangeColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300,
                                                decoration:
                                                    TextDecoration.underline),
                                      ).tr()),
                                ],
                              ),
                            if (Provider.of<ProfileViewModel>(context,
                                    listen: true)
                                .getHealthRecord
                                .desc
                                .isNotEmpty)
                              Align(
                                alignment: context.locale == Locale('en')
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 2),
                                  child: Text(
                                    'Description',
                                    style: theme.textTheme.bodySmall!
                                        .copyWith(fontWeight: FontWeight.w300),
                                  ).tr(),
                                ),
                              ),
                            Consumer<ProfileViewModel>(
                              builder: (context, user, child) => user
                                      .getHealthRecord.desc.isEmpty
                                  ? const Text('')
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: mq.size.width * 0.95,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(color: blueColor),
                                        ),
                                        child: Text(
                                          user.getHealthRecord.desc,
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                            ),
                            if (Provider.of<ProfileViewModel>(context,
                                    listen: true)
                                .getHealthRecord
                                .diseases
                                .isNotEmpty)
                              Align(
                                alignment: context.locale == Locale('en')
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 2),
                                  child: Text(
                                    'Diseases',
                                    style: theme.textTheme.bodySmall!
                                        .copyWith(fontWeight: FontWeight.w300),
                                  ).tr(),
                                ),
                              ),
                            Consumer<ProfileViewModel>(
                              builder: (context, user, child) => user
                                      .getHealthRecord.diseases.isEmpty
                                  ? const Text('')
                                  : ListBody(
                                      children: user.getHealthRecord.diseases
                                          .map(
                                            (e) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                              child: Text(
                                                  e['dis_name'].toString(),
                                                  style: theme
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                          color: blueColor)),
                                            ),
                                          )
                                          .toList(),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildWorkoutList(
      BuildContext context, int index, WorkoutListModel workoutValue) {
    final mq = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/anotherUserProfile',
                  arguments: {'id': workoutValue.user_id});
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        workoutValue.prof_img_url.toString().substring(0, 4) !=
                                'http'
                            ? '$ip/${workoutValue.prof_img_url}'
                            : workoutValue.prof_img_url.toString()
                        // 'https://media.istockphoto.com/photos/various-sport-equipments-on-grass-picture-id949190756?s=612x612',
                        ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${workoutValue.f_name} ${workoutValue.l_name}',
                      style:
                          theme.textTheme.bodySmall!.copyWith(color: blueColor),
                    ),
                    Text(
                      '${workoutValue.created_at}',
                      style: theme.textTheme.displaySmall!
                          .copyWith(color: greyColor, fontSize: 10),
                    )
                  ],
                )
              ],
            ),
          ),
          /*   PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Favorite',
                child: Text(
                  workoutValue.saved != true
                      ? 'Add to favorite'.tr()
                      : 'Deleted form favorite'.tr(),
                  style: TextStyle(color: orangeColor),
                ),
              ),
              if ((sharedPreferences.get("role_id") == 2 ) ||
                  sharedPreferences.get("role_id") == 4 ||
                  sharedPreferences.get("role_id") == 5)
                PopupMenuItem(
                  child: Text(
                    'Edit'.tr(),
                    style: TextStyle(color: orangeColor),
                  ),
                  value: 'Edit',
                ),
              if ((sharedPreferences.get("role_id") == 2 ) ||
                  sharedPreferences.get("role_id") == 4 ||
                  sharedPreferences.get("role_id") == 5)
                PopupMenuItem(
                  child: Text(
                    'Delete'.tr(),
                    style: TextStyle(color: Colors.red),
                  ),
                  value: 'Delete',
                ),
            ],
            onSelected: (newVal) async {
              if (newVal == 'Favorite') {
                final WorkoutListModel? BackEndMessage =
                    await Provider.of<WorkoutListViewModel>(context,
                            listen: false)
                        .changeFavoriteState(
                            context.locale == Locale('en') ? 'en' : 'ar',
                            workoutValue.id!.toInt());
                if (BackEndMessage!.message != '' ||
                    BackEndMessage.message != '') {
                  showSnackbar(
                      Text(BackEndMessage.message.toString()), context);
                }
                if (BackEndMessage.statusCode == 200) {
                  Provider.of<WorkoutListViewModel>(context, listen: false)
                      .resetForFilter();
                  Provider.of<WorkoutListViewModel>(context, listen: false)
                      .getWorkoutsData(
                          context.locale == Locale('en') ? 'en' : 'ar',
                          Provider.of<WorkoutListViewModel>(context,
                                  listen: false)
                              .page,
                          Provider.of<WorkoutListViewModel>(context,
                                  listen: false)
                              .CategoryNumber,
                          Provider.of<WorkoutListViewModel>(context,
                                  listen: false)
                              .DifficultyNumber,
                          '/workout/filter');
                }
              } else if (newVal == 'Edit') {
                print(workoutValue.id);
                await Navigator.of(context)
                    .pushNamed('/editWorkout', arguments: {
                  // 'Categories IDs': workoutValue.,
                  'name': workoutValue.name,
                  'description': workoutValue.description,
                  'id': workoutValue.id,
                });
                Provider.of<WorkoutListViewModel>(context, listen: false)
                    .resetForFilter();
                Provider.of<WorkoutListViewModel>(context, listen: false)
                    .getWorkoutsData(
                        context.locale == Locale('en') ? 'en' : 'ar',
                        Provider.of<WorkoutListViewModel>(context,
                                listen: false)
                            .page,
                        Provider.of<WorkoutListViewModel>(context,
                                listen: false)
                            .CategoryNumber,
                        Provider.of<WorkoutListViewModel>(context,
                                listen: false)
                            .DifficultyNumber,
                        '/workout/filter');
              } else if (newVal == 'Delete') {
                print('yes');
                final WorkoutListModel BackEndMessage =
                    await Provider.of<WorkoutListViewModel>(context,
                            listen: false)
                        .deleteSpecificWorkout(
                            context.locale == Locale('en') ? 'en' : 'ar',
                            workoutValue.id);
                if (BackEndMessage.message != '' ||
                    BackEndMessage.message != '') {
                  showSnackbar(
                      Text(BackEndMessage.message.toString()), context);
                }
                if (BackEndMessage.statusCode == 200) {
                  Provider.of<WorkoutListViewModel>(context, listen: false)
                      .resetForFilter();
                  Provider.of<WorkoutListViewModel>(context, listen: false)
                      .getWorkoutsData(
                          context.locale == Locale('en') ? 'en' : 'ar',
                          Provider.of<WorkoutListViewModel>(context,
                                  listen: false)
                              .page,
                          Provider.of<WorkoutListViewModel>(context,
                                  listen: false)
                              .CategoryNumber,
                          Provider.of<WorkoutListViewModel>(context,
                                  listen: false)
                              .DifficultyNumber,
                          '/workout/filter');
                }
              }
            },
          ),
       */
        ]),
        InkWell(
          onTap: () {
            //TODO:
            Navigator.pushNamed(context, '/specificWorkout',
                arguments: {'workoutId': workoutValue.id});
          },
          child: Container(
            width: mq.width * 0.95,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: blueColor, width: 2),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress != null
                            ? const LoadingContainer()
                            : child,
                    width: mq.width * 0.95,
                    height: 250,
                    fit: BoxFit.cover,
                    image: NetworkImage(workoutValue.workout_image_url
                                    .toString()
                                    .substring(0, 4) !=
                                'http'
                            ? '$ip/${workoutValue.workout_image_url}'
                            : workoutValue.workout_image_url.toString()
                        // 'https://media.istockphoto.com/photos/various-sport-equipments-on-grass-picture-id949190756?s=612x612',
                        ),
                  ),
                ),
                Container(
                  width: mq.width * 0.95,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                          color: orangeColor.withOpacity(0.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FittedBox(
                                child: Text(workoutValue.name.toString(),
                                    style: TextStyle(
                                        color: blueColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25)),
                              ),
                              FittedBox(
                                child: Text(
                                  '$exer ${workoutValue.excersise_count}',
                                  style: theme.textTheme.displaySmall,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    Icons.alarm,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  Text(
                                    '${workoutValue.length} $min',
                                    style: theme.textTheme.displaySmall!
                                        .copyWith(fontSize: 15),
                                  )
                                ],
                              ),
                              // FittedBox(
                              //   child: Text(
                              //     'Published by:\ncoach ${e.publisherName}',
                              //     style: theme.textTheme.displaySmall,
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          color: orangeColor.withOpacity(0.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FittedBox(
                                child: Text(
                                  ' ',
                                  style: theme.textTheme.displaySmall,
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  '${workoutValue.predicted_burnt_calories} $kcal',
                                  style: theme.textTheme.displaySmall,
                                ),
                              ),
                              Icon(
                                Icons.electric_bolt_rounded,
                                color: workoutValue.difficulty == 1
                                    ? Colors.green
                                    : (workoutValue.difficulty == 2
                                        ? Colors.yellow
                                        : Colors.red),
                                size: 25,
                              ),
                              FittedBox(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    workoutValue.description.toString(),
                                    style: theme.textTheme.displaySmall,
                                    overflow: TextOverflow.fade,
                                    maxLines: 3,
                                    // softWrap: false,
                                    // textAlign: TextAlign.left,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
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
