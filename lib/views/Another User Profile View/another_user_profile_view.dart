// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_workout_app/models/user_model.dart';
import 'package:home_workout_app/models/workout_list_model.dart';
import 'package:home_workout_app/view_models/another_user_profile_view_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../view_models/Diet View Model/Diet/diet_list_view_model.dart';
import '../../view_models/profile_view_model.dart';
import '../Home View/Mobile/mobile_home_view_widgets.dart';
import '../Home View/home_view_widgets.dart';
import '../Posts View/post_view_widgets.dart';

class AnotherUserProfileView extends StatefulWidget {
  const AnotherUserProfileView({Key? key}) : super(key: key);

  @override
  State<AnotherUserProfileView> createState() => _AnotherUserProfileViewState();
}

class _AnotherUserProfileViewState extends State<AnotherUserProfileView> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _reviewController = TextEditingController();
  String exer = 'Exercises:'.tr();
  String min = 'min'.tr();
  String kcal = 'Kcal'.tr();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      Duration.zero,
    ).then((value) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;

      if (Provider.of<ProfileViewModel>(context, listen: false)
              .getUserData
              .id
              .toString() ==
          args['id'].toString()) {
        log('sssssssssssssssssss');
        Navigator.pushNamed(context, '/home', arguments: {'page': 3});
      }

      Provider.of<AnotherUserProfileViewModel>(context, listen: false)
          .setUserData(args['id'], context);
      Provider.of<ProfileViewModel>(context, listen: false)
          .setInfoWidgetVisible(false);

      _scrollController.addListener(() {
        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            Provider.of<AnotherUserProfileViewModel>(context, listen: false)
                .getPostIsOpened) {
          Provider.of<AnotherUserProfileViewModel>(context, listen: false)
              .setAnotherUserPosts(
                  context.locale == const Locale('en') ? 'en' : 'ar',
                  Provider.of<AnotherUserProfileViewModel>(context,
                          listen: false)
                      .getUserData
                      .id,
                  context);
        }

        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            Provider.of<AnotherUserProfileViewModel>(context, listen: false)
                .getDietIsOpened) {
          Provider.of<AnotherUserProfileViewModel>(context, listen: false)
              .setAnotherUserDiets(
                  context.locale == const Locale('en') ? 'en' : 'ar',
                  Provider.of<AnotherUserProfileViewModel>(context,
                          listen: false)
                      .getUserData
                      .id);
        }

        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            Provider.of<AnotherUserProfileViewModel>(context, listen: false)
                .getWorkoutIsOpened) {
          Provider.of<AnotherUserProfileViewModel>(context, listen: false)
              .setAnotherUserWorkouts(
                  lang: context.locale == const Locale('en') ? 'en' : 'ar',
                  userId: Provider.of<AnotherUserProfileViewModel>(context,
                          listen: false)
                      .getUserData
                      .id);
        }
      });
    });
  }

  String finishedWorkouts = 'Finished Workouts'.tr();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(),
        body: Provider.of<AnotherUserProfileViewModel>(context, listen: true)
                .getIsLoading
            ? const CustomLoading()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AnimatedOpacity(
                      opacity: Provider.of<AnotherUserProfileViewModel>(context,
                                  listen: true)
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
                                Consumer<AnotherUserProfileViewModel>(
                                  builder: (context, user, child) =>
                                      CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(user.getUserData.imageUrl),
                                    onBackgroundImageError:
                                        (child, stacktrace) =>
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
                                  child: Consumer<AnotherUserProfileViewModel>(
                                    builder: (context, user, child) => Text(
                                      '${user.getUserData.fname} ${user.getUserData.lname}',
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (Provider.of<AnotherUserProfileViewModel>(
                                    context,
                                    listen: true)
                                .getMoreLoading)
                              bigLoader(color: orangeColor)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<AnotherUserProfileViewModel>(context,
                                listen: false)
                            .setUserData(
                                Provider.of<AnotherUserProfileViewModel>(
                                        context,
                                        listen: false)
                                    .getUserData
                                    .id,
                                context);
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        controller: _scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Consumer<AnotherUserProfileViewModel>(
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
                                    onBackgroundImageError:
                                        (child, stacktrace) =>
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
                            Consumer<AnotherUserProfileViewModel>(
                              builder: (context, user, child) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${user.getUserData.fname} ${user.getUserData.lname}',
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.black),
                                  ),
                                  if (user.getUserData.roleId == 3 ||
                                      user.getUserData.roleId == 2)
                                    Text(
                                      ' ( ${user.getUserData.role.toUpperCase()} )',
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        fontSize: 15,
                                        color: user.getUserData.roleId == 2
                                            ? orangeColor
                                            : (user.getUserData.roleId == 3
                                                ? blueColor
                                                : Colors.transparent),
                                      ),
                                    ),
                                  Align(
                                    alignment: context.locale == Locale('en')
                                        ? Alignment.topRight
                                        : Alignment.topLeft,
                                    child:
                                        Consumer<AnotherUserProfileViewModel>(
                                      builder: (context, user, child) =>
                                          PopupMenuButton<String>(
                                        icon:
                                            const Icon(Icons.more_vert_rounded),
                                        onSelected: (String result) {
                                          switch (result) {
                                            case 'send':
                                              Navigator.pushNamed(
                                                  context, '/chat', arguments: {
                                                'id': user.getUserData.id
                                              });
                                              break;
                                            case 'block':
                                              if (user.getUserData.i_block)
                                                user.unblockUser(
                                                    user.getUserData.id,
                                                    context.locale ==
                                                            Locale('en')
                                                        ? 'en'
                                                        : 'ar',
                                                    context);
                                              else
                                                user.blockUser(
                                                    user.getUserData.id,
                                                    context.locale ==
                                                            Locale('en')
                                                        ? 'en'
                                                        : 'ar',
                                                    context);

                                              break;
                                            default:
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          if (Provider.of<AnotherUserProfileViewModel>(
                                                          context,
                                                          listen: false)
                                                      .getUserData
                                                      .roleId ==
                                                  2 ||
                                              Provider.of<AnotherUserProfileViewModel>(
                                                          context,
                                                          listen: false)
                                                      .getUserData
                                                      .roleId ==
                                                  3)
                                            PopupMenuItem<String>(
                                                value: 'send',
                                                child: Text(
                                                  'Send a message',
                                                  style: theme
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                          color: blueColor),
                                                ).tr()),
                                          if (Provider.of<ProfileViewModel>(
                                                          context,
                                                          listen: false)
                                                      .getUserData
                                                      .roleId ==
                                                  2 ||
                                              Provider.of<ProfileViewModel>(
                                                          context,
                                                          listen: false)
                                                      .getUserData
                                                      .roleId ==
                                                  3)
                                            PopupMenuItem<String>(
                                              value: 'block',
                                              child: Text(
                                                user.getUserData.i_block
                                                    ? 'unblock'
                                                    : 'Block',
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: Colors.red),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Consumer<AnotherUserProfileViewModel>(
                              builder: (context, user, child) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (user.getUserData.roleId == 2 ||
                                      user.getUserData.roleId == 3)
                                    SizedBox(
                                      width: 80,
                                      height: 25,
                                      child: user.getIsLoading
                                          ? CustomLoading()
                                          : ElevatedButton(
                                              style: theme
                                                  .elevatedButtonTheme.style!
                                                  .copyWith(
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    side: BorderSide(
                                                      color: !user.getUserData
                                                              .followed
                                                          ? Colors.transparent
                                                          : blueColor,
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        !user.getUserData
                                                                .followed
                                                            ? blueColor
                                                            : Colors.white),
                                              ),
                                              onPressed: () {
                                                if (!user.getUserData.followed)
                                                  user.setFollow(
                                                      user.getUserData.id,
                                                      context.locale ==
                                                              Locale('en')
                                                          ? 'en'
                                                          : 'ar',
                                                      context);
                                                else
                                                  user.setUnfollow(
                                                      user.getUserData.id,
                                                      context.locale ==
                                                              Locale('en')
                                                          ? 'en'
                                                          : 'ar',
                                                      context);
                                              },
                                              child: Text(
                                                !user.getUserData.followed
                                                    ? '+ Follow'
                                                    : 'Unfollow',
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: !user.getUserData
                                                                .followed
                                                            ? Colors.white
                                                            : blueColor,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontSize: 12),
                                              ).tr(),
                                            ),
                                    ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                            user.getUserData.followers
                                                .toString(),
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
                                          user.getUserData.followings
                                              .toString(),
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
                            Consumer<AnotherUserProfileViewModel>(
                              builder: (context, user, child) => user
                                          .getUserData.bio ==
                                      ''
                                  ? const Text('')
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
                                        style:
                                            theme.textTheme.bodySmall!.copyWith(
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                            ),
                            // if (Provider.of<AnotherUserProfileViewModel>(context,
                            //                 listen: true)
                            //             .getUserData
                            //             .roleId ==
                            //         2 &&
                            //     Provider.of<AnotherUserProfileViewModel>(context,
                            //                 listen: true)
                            //             .getUserData
                            //             .roleId !=
                            //         0)
                            //   ExpansionTile(
                            //     iconColor: blueColor,
                            //     title: Text(
                            //       'Shared workouts',
                            //       style: theme.textTheme.bodySmall,
                            //     ).tr(),
                            //   ),
                            if (Provider.of<AnotherUserProfileViewModel>(
                                            context,
                                            listen: true)
                                        .getUserData
                                        .roleId ==
                                    2 ||
                                Provider.of<ProfileViewModel>(context,
                                            listen: true)
                                        .getUserData
                                        .roleId ==
                                    4 ||
                                Provider.of<ProfileViewModel>(context,
                                            listen: true)
                                        .getUserData
                                        .roleId ==
                                    5)
                              Consumer<AnotherUserProfileViewModel>(
                                builder: (context, user, child) =>
                                    ExpansionTile(
                                  onExpansionChanged: (change) async {
                                    if (change) {
                                      user.setWorkoutIsOpened(true);
                                      user.setWorkoutPage(0);
                                      user.clearWorkouts();
                                      await user.setAnotherUserWorkouts(
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
                                                child: bigLoader(
                                                    color: orangeColor)),
                                          ),
                                        ]
                                      : user.getUserWorkouts
                                          .map(
                                            (e) => _buildWorkoutList(
                                                context, 1, e),
                                          )
                                          .toList(),
                                ),
                              ),
                            if (Provider.of<AnotherUserProfileViewModel>(
                                            context,
                                            listen: true)
                                        .getUserData
                                        .roleId !=
                                    1 &&
                                Provider.of<AnotherUserProfileViewModel>(
                                            context,
                                            listen: true)
                                        .getUserData
                                        .roleId !=
                                    2)
                              Consumer<AnotherUserProfileViewModel>(
                                builder: (context, user, child) =>
                                    ExpansionTile(
                                  onExpansionChanged: (change) async {
                                    if (change) {
                                      user.setDietIsOpened(true);
                                      user.setDietPage(0);
                                      user.clearDiets();
                                      await user.setAnotherUserDiets(
                                          context.locale == const Locale('en')
                                              ? 'en'
                                              : 'ar',
                                          user.getUserData.id);
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
                                  children:
                                      (user.getIsDietLogoutLoading &&
                                              user.getUserDiets.isEmpty)
                                          ? [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: bigLoader(
                                                        color: orangeColor)),
                                              ),
                                            ]
                                          : user.getUserDiets
                                              .map(
                                                (e) => InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/specDiet',
                                                        arguments: {
                                                          'dietId': e.id
                                                        });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: blueColor,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ListTile(
                                                            trailing:
                                                                PopupMenuButton(
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
                                                                          'diet':
                                                                              e
                                                                        });
                                                                    break;

                                                                  case 'save':
                                                                    final response = await Provider.of<DietListViewModel>(context, listen: false).saveDiet(
                                                                        lang: getLang(
                                                                            context),
                                                                        id: e
                                                                            .id,
                                                                        context:
                                                                            context);
                                                                    if (response) {
                                                                      setState(
                                                                          () {
                                                                        e.saved =
                                                                            !e.saved;
                                                                      });
                                                                    }
                                                                    break;

                                                                  case 'delete':
                                                                    await Provider.of<AnotherUserProfileViewModel>(context, listen: false).deleteDiet(
                                                                        lang: getLang(
                                                                            context),
                                                                        id: e
                                                                            .id,
                                                                        context:
                                                                            context);
                                                                    break;
                                                                  default:
                                                                }
                                                              },
                                                              itemBuilder:
                                                                  (context) => [
                                                                PopupMenuItem(
                                                                    value:
                                                                        'save',
                                                                    child: Text(
                                                                      e.saved
                                                                          ? 'Saved'
                                                                          : 'Save',
                                                                      style: theme
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .copyWith(
                                                                              color: e.saved ? Colors.amber : blueColor),
                                                                    ).tr()),
                                                                if (Provider.of<ProfileViewModel>(context, listen: false).getUserData.roleId == 4 ||
                                                                    Provider.of<ProfileViewModel>(context, listen: false)
                                                                            .getUserData
                                                                            .roleId ==
                                                                        5 ||
                                                                    Provider.of<ProfileViewModel>(context, listen: false)
                                                                            .getUserData
                                                                            .id ==
                                                                        e
                                                                            .userId)
                                                                  PopupMenuItem(
                                                                      value:
                                                                          'edit',
                                                                      child:
                                                                          Text(
                                                                        'Edit',
                                                                        style: theme
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .copyWith(color: blueColor),
                                                                      ).tr()),
                                                                if (Provider.of<ProfileViewModel>(context, listen: false).getUserData.roleId == 4 ||
                                                                    Provider.of<ProfileViewModel>(context, listen: false)
                                                                            .getUserData
                                                                            .roleId ==
                                                                        5 ||
                                                                    Provider.of<ProfileViewModel>(context, listen: false)
                                                                            .getUserData
                                                                            .id ==
                                                                        e
                                                                            .userId)
                                                                  PopupMenuItem(
                                                                      value:
                                                                          'delete',
                                                                      child:
                                                                          Text(
                                                                        'Delete',
                                                                        style: theme
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .copyWith(color: Colors.red),
                                                                      ).tr())
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        25,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              e.name,
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        25,
                                                                    vertical:
                                                                        10),
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
                                                                  style: theme
                                                                      .textTheme
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
                                                                          vertical:
                                                                              10),
                                                                      child:
                                                                          RatingBarIndicator(
                                                                        rating:
                                                                            e.rating,
                                                                        itemSize:
                                                                            25,
                                                                        itemCount:
                                                                            5,
                                                                        itemBuilder:
                                                                            (context, index) =>
                                                                                const Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              Colors.amber,
                                                                        ),
                                                                      )),
                                                                  Text(
                                                                    e.rating
                                                                        .toString(),
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
                                                                        'id': e
                                                                            .id,
                                                                        'review':
                                                                            true,
                                                                        'isReviewd':
                                                                            e.reviewd,
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
                                                          if (Provider.of<ProfileViewModel>(
                                                                          context,
                                                                          listen:
                                                                              true)
                                                                      .getUserData
                                                                      .id !=
                                                                  e.userId &&
                                                              e.reviewd ==
                                                                  false)
                                                            Center(
                                                              child: Consumer<
                                                                  DietListViewModel>(
                                                                builder: (context,
                                                                        review,
                                                                        child) =>
                                                                    review.getIsREviewLoading
                                                                        ? Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                bigLoader(color: orangeColor),
                                                                          )
                                                                        : TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext ctx) {
                                                                                    _reviewController.clear();
                                                                                    double stars = 0;
                                                                                    return AlertDialog(
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                                      content: Container(
                                                                                          height: 240,
                                                                                          child: Column(
                                                                                            children: [
                                                                                              RatingBar.builder(
                                                                                                itemCount: 5,
                                                                                                allowHalfRating: true,
                                                                                                unratedColor: greyColor,
                                                                                                //initialRating: e.rating,
                                                                                                maxRating: 5,
                                                                                                itemBuilder: (context, index) => const Icon(
                                                                                                  Icons.star,
                                                                                                  color: Colors.amber,
                                                                                                ),
                                                                                                onRatingUpdate: (value) {
                                                                                                  stars = value;
                                                                                                  return;
                                                                                                },
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                child: CustomTextField(maxLines: 5, controller: _reviewController, title: 'Comment'),
                                                                                              ),
                                                                                              ElevatedButton(
                                                                                                  onPressed: () async {
                                                                                                    Navigator.pop(ctx);
                                                                                                    final response = await review.sendReview(lang: getLang(context), id: e.id, review: _reviewController.text.trim(), stars: stars, context: context);
                                                                                                    if (response) {
                                                                                                      setState(() {
                                                                                                        e.reviewd = true;
                                                                                                      });
                                                                                                    }
                                                                                                    _reviewController.clear();
                                                                                                  },
                                                                                                  child: const Text('Submit')),
                                                                                            ],
                                                                                          )),
                                                                                    );
                                                                                  });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Add a review',
                                                                              style: theme.textTheme.bodySmall!.copyWith(color: Colors.amber),
                                                                            ),
                                                                          ),
                                                              ),
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
                            if (Provider.of<AnotherUserProfileViewModel>(
                                        context,
                                        listen: true)
                                    .getUserData
                                    .roleId !=
                                1)
                              Consumer<AnotherUserProfileViewModel>(
                                builder: (context, user, child) =>
                                    ExpansionTile(
                                  onExpansionChanged: (change) async {
                                    if (change) {
                                      user.setPostIsOpened(true);
                                      user.setPage(0);
                                      user.clearPosts();
                                      await user.setAnotherUserPosts(
                                          context.locale == const Locale('en')
                                              ? 'en'
                                              : 'ar',
                                          user.getUserData.id,
                                          context);
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
                                  children: (user.getIsPostLoading &&
                                          user.getUserPosts.isEmpty)
                                      ? [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: bigLoader(
                                                    color: orangeColor)),
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
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceAround,
                            //       children: [
                            //         Consumer<AnotherUserProfileViewModel>(
                            //           builder: (context, user, child) =>
                            //               CircularPercentIndicator(
                            //             radius: 50,
                            //             animation: true,
                            //             center: Text(
                            //               '$finishedWorkouts \n ${user.getUserData.finishedWorkouts}/${user.getUserData.enteredWorkouts}',
                            //               textAlign: TextAlign.center,
                            //               style: theme.textTheme.bodySmall!
                            //                   .copyWith(
                            //                       fontSize: 10,
                            //                       color: blueColor),
                            //             ),
                            //             progressColor: blueColor,
                            //             percent: user
                            //                     .getUserData.finishedWorkouts /
                            //                 user.getUserData.enteredWorkouts,
                            //           ),
                            //         ),
                            //       ],
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
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
              if ((sharedPreferences.get("role_id") == 2) ||
                  sharedPreferences.get("role_id") == 4 ||
                  sharedPreferences.get("role_id") == 5)
                PopupMenuItem(
                  child: Text(
                    'Edit'.tr(),
                    style: TextStyle(color: orangeColor),
                  ),
                  value: 'Edit',
                ),
              if ((sharedPreferences.get("role_id") == 2) ||
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
