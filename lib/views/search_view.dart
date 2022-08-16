// ignore_for_file: curly_braces_in_flow_control_structures, prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/challenge_model.dart';
import 'package:home_workout_app/view_models/search_view_model.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../view_models/Diet View Model/Diet/diet_list_view_model.dart';
import '../view_models/Workout_View_Model/workout_list_view_model.dart';
import '../view_models/general_challenges_view_model.dart';
import '../view_models/profile_view_model.dart';
import 'Home View/Mobile/mobile_home_view_widgets.dart';
import 'Home View/home_view_widgets.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  TextEditingController _reviewController = TextEditingController();
  String exer = 'Exercises:'.tr();
  String min = 'min'.tr();
  String kcal = 'Kcal'.tr();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<SearchViewModel>(context, listen: false).reset();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<SearchViewModel>(context, listen: false).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: TextField(
                onChanged: (value) async {
                  if (value.isNotEmpty)
                    await Provider.of<SearchViewModel>(context, listen: false)
                        .getSuggestion(
                            lang: getLang(context),
                            text: value,
                            context: context);
                },
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  label: FittedBox(child: const Text('Search').tr()),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
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
              )),
              TextButton(
                  onPressed: () async {
                    if (!_scrollController.hasListeners) {
                      _scrollController.addListener(() {
                        if (_scrollController.offset ==
                            _scrollController.position.maxScrollExtent) {
                          print('ciiiiiiiiiiiiiiii');

                          Provider.of<SearchViewModel>(context, listen: false)
                              .getSearchData(
                                  lang: getLang(context),
                                  text: _controller.text.trim(),
                                  context: context);
                        }
                      });
                    }
                    Provider.of<SearchViewModel>(context, listen: false)
                        .reset();

                    await Provider.of<SearchViewModel>(context, listen: false)
                        .getSearchData(
                            lang: getLang(context),
                            text: _controller.text.trim(),
                            context: context);
                  },
                  child: Provider.of<SearchViewModel>(context, listen: true)
                          .getIsLoading
                      ? smallLoader(color: orangeColor)
                      : Text(
                          'Go',
                          style: theme.textTheme.bodySmall,
                        ).tr())
            ],
          ),
        ),
      ),
      body: Consumer<SearchViewModel>(
        builder: (context, search, child) => Column(
          children: [
            if (search.getSugs.isNotEmpty)
              ListBody(
                children: search.getSugs
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              _controller.text = e.toString();
                            },
                            child: Text(
                              e,
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: greyColor),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            if (search.getIsSugLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: bigLoader(color: orangeColor),
              ),
            Divider(
              indent: 50,
              endIndent: 50,
              color: blueColor,
            ),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Consumer<SearchViewModel>(
                  builder: (context, consumer, child) => Row(
                    children: consumer.categories.entries
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              consumer.changeSelectedCategorie(e.key, true);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  color: e.value ? blueColor : greyColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  e.key,
                                  style: theme.textTheme.bodySmall!.copyWith(
                                      color: Colors.white,
                                      fontSize: e.value ? 15 : 10),
                                ).tr(),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                controller: _scrollController,
                child: Builder(builder: (context) {
                  print('aaaaaaaaaa' + search.getFilter());
                  switch (search.getFilter()) {
                    case 'Users':
                      if (search.getUsers.isEmpty)
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mq.size.width * 0.5),
                            child: Text(
                              'There are no search results',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: greyColor),
                            ).tr(),
                          ),
                        );
                      else
                        return Column(
                          children: search.getUsers
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/anotherUserProfile',
                                          arguments: {'id': e.id});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: blueColor, width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(e.imageUrl),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${e.role} ${'${e.fname} ${e.lname}'}',
                                                  style: theme
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                          color: blueColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );

                    /////////////////////

                    case 'Posts':
                      if (search.getposts.isEmpty)
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mq.size.width * 0.5),
                            child: Text(
                              'There are no search results',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: greyColor),
                            ).tr(),
                          ),
                        );
                      return Column(
                        children: search.getposts.map<Widget>((e) {
                          if (e.type == 2 || e.type == 3)
                            return pollPostCard(post: e, ctx: context);
                          else
                            return NormalPostCard(post: e, ctx: context);
                        }).toList(),
                      );

                    case 'Diets':
                      if (search.getDiets.isEmpty)
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mq.size.width * 0.5),
                            child: Text(
                              'There are no search results',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: greyColor),
                            ).tr(),
                          ),
                        );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: search.getDiets
                            .map(
                              (e) => InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/specDiet',
                                      arguments: {'dietId': e.id});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: blueColor, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/anotherUserProfile',
                                                arguments: {'id': e.userId});
                                          },
                                          child: ListTile(
                                            trailing: PopupMenuButton(
                                              onSelected: (value) async {
                                                switch (value) {
                                                  case 'edit':
                                                    Navigator.pushNamed(
                                                        context, '/editDiet',
                                                        arguments: {
                                                          'dietId': e.id,
                                                          'diet': e
                                                        });
                                                    break;

                                                  case 'save':
                                                    final response = await Provider
                                                            .of<DietListViewModel>(
                                                                context,
                                                                listen: false)
                                                        .saveDiet(
                                                            lang: getLang(
                                                                context),
                                                            id: e.id,
                                                            context: context);
                                                    if (response) {
                                                      setState(() {
                                                        e.saved = !e.saved;
                                                      });
                                                    }
                                                    break;

                                                  case 'delete':
                                                    await Provider.of<
                                                                SearchViewModel>(
                                                            context,
                                                            listen: false)
                                                        .deleteDiet(
                                                            lang: getLang(
                                                                context),
                                                            id: e.id,
                                                            context: context);
                                                    break;
                                                  default:
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    value: 'save',
                                                    child: Text(
                                                      e.saved
                                                          ? 'Saved'
                                                          : 'Save',
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color: e.saved
                                                                  ? Colors.amber
                                                                  : blueColor),
                                                    ).tr()),
                                                if (Provider.of<ProfileViewModel>(
                                                                context,
                                                                listen: false)
                                                            .getUserData
                                                            .roleId ==
                                                        4 ||
                                                    Provider.of<ProfileViewModel>(
                                                                context,
                                                                listen: false)
                                                            .getUserData
                                                            .roleId ==
                                                        5 ||
                                                    Provider.of<ProfileViewModel>(
                                                                context,
                                                                listen: false)
                                                            .getUserData
                                                            .id ==
                                                        e.userId)
                                                  PopupMenuItem(
                                                      value: 'edit',
                                                      child: Text(
                                                        'Edit',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color:
                                                                    blueColor),
                                                      ).tr()),
                                                if (Provider.of<ProfileViewModel>(
                                                                context,
                                                                listen: false)
                                                            .getUserData
                                                            .roleId ==
                                                        4 ||
                                                    Provider.of<ProfileViewModel>(
                                                                context,
                                                                listen: false)
                                                            .getUserData
                                                            .roleId ==
                                                        5 ||
                                                    Provider.of<ProfileViewModel>(
                                                                context,
                                                                listen: false)
                                                            .getUserData
                                                            .id ==
                                                        e.userId)
                                                  PopupMenuItem(
                                                      value: 'delete',
                                                      child: Text(
                                                        'Delete',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color:
                                                                    Colors.red),
                                                      ).tr())
                                              ],
                                            ),
                                            title: Text(
                                              '${e.userFname} ${e.userLname}',
                                              style: theme.textTheme.bodySmall!
                                                  .copyWith(color: orangeColor),
                                            ),
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(e.userImg),
                                            ),
                                            subtitle: Text(
                                              e.createAt,
                                              style: theme.textTheme.bodySmall!
                                                  .copyWith(
                                                      color: greyColor,
                                                      fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          child: Text(
                                            e.name,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          child: Row(
                                            children: [
                                              Text('Meals: ',
                                                      style: theme
                                                          .textTheme.bodySmall)
                                                  .tr(),
                                              Text(
                                                e.mealsCount.toString(),
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(color: greyColor),
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
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25,
                                                        vertical: 10),
                                                    child: RatingBarIndicator(
                                                      rating: e.rating,
                                                      itemSize: 25,
                                                      itemCount: 5,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                    )),
                                                Text(
                                                  e.rating.toString(),
                                                  style: theme
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                          color: greyColor),
                                                ),
                                              ],
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/comments',
                                                    arguments: {
                                                      'review': true,
                                                      'isReviewd': e.reviewd,
                                                      'id': e.id
                                                    });
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Comments',
                                                    style: theme
                                                        .textTheme.bodySmall,
                                                  ).tr(),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 15,
                                                    color: orangeColor,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        if (Provider.of<ProfileViewModel>(
                                                        context,
                                                        listen: true)
                                                    .getUserData
                                                    .id !=
                                                e.userId &&
                                            e.reviewd == false)
                                          Center(
                                            child: TextButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext ctx) {
                                                      double stars = 0;
                                                      return AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        content: Container(
                                                            height: 240,
                                                            child: Column(
                                                              children: [
                                                                RatingBar
                                                                    .builder(
                                                                  itemCount: 5,
                                                                  allowHalfRating:
                                                                      true,
                                                                  unratedColor:
                                                                      greyColor,
                                                                  //initialRating: e.rating,
                                                                  maxRating: 5,
                                                                  itemBuilder: (context,
                                                                          index) =>
                                                                      const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                  onRatingUpdate:
                                                                      (value) {
                                                                    stars =
                                                                        value;
                                                                    return;
                                                                  },
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: CustomTextField(
                                                                      maxLines:
                                                                          5,
                                                                      controller:
                                                                          _reviewController,
                                                                      title:
                                                                          'Comment'),
                                                                ),
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      final response = await Provider.of<DietListViewModel>(context, listen: false).sendReview(
                                                                          lang: getLang(
                                                                              context),
                                                                          id: e
                                                                              .id,
                                                                          review: _reviewController
                                                                              .text
                                                                              .trim(),
                                                                          stars:
                                                                              stars,
                                                                          context:
                                                                              context);
                                                                      if (response) {
                                                                        setState(
                                                                            () {
                                                                          e.reviewd =
                                                                              true;
                                                                        });
                                                                        _reviewController
                                                                            .clear();
                                                                        Navigator.pop(
                                                                            ctx);
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'Submit'))
                                                              ],
                                                            )),
                                                      );
                                                    });
                                              },
                                              child: Text(
                                                'Add a review',
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: Colors.amber),
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
                      );

                    case 'Challenges':
                      if (search.getChallenges.isEmpty)
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mq.size.width * 0.5),
                            child: Text(
                              'There are no search results',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: greyColor),
                            ).tr(),
                          ),
                        );
                      return Column(
                        children: search.getChallenges
                            .map((challengeValue) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: mq.size.width * 0.01,
                                    vertical: mq.size.height * 0.01),
                                child: Container(
                                  // height: mq.size.height * 0.3,
                                  // width: mq.size.width * 0.95,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 30,
                                          offset: Offset(10, 15),
                                        )
                                      ]),
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    '/anotherUserProfile',
                                                    arguments: {
                                                      'id':
                                                          challengeValue.user_id
                                                    });
                                              },
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          challengeValue
                                                                      .user_img
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          4) !=
                                                                  'http'
                                                              ? '$ip/${challengeValue.user_img}'
                                                              : challengeValue
                                                                  .user_img
                                                                  .toString()
                                                          // 'https://media.istockphoto.com/photos/various-sport-equipments-on-grass-picture-id949190756?s=612x612'
                                                          ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${challengeValue.user_name}',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color:
                                                                    blueColor),
                                                      ),
                                                      Text(
                                                        '${challengeValue.created_at}',
                                                        style: theme.textTheme
                                                            .displaySmall!
                                                            .copyWith(
                                                                color:
                                                                    greyColor,
                                                                fontSize: 10),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ), //&& challengeValue.user_id == sharedPreferences.get("user_id")
                                            if ((sharedPreferences
                                                        .get("role_id") ==
                                                    2) ||
                                                sharedPreferences
                                                        .get("role_id") ==
                                                    4 ||
                                                sharedPreferences
                                                        .get("role_id") ==
                                                    5)
                                              PopupMenuButton(
                                                itemBuilder: (context) => [
                                                  /* PopupMenuItem(
                  child: Text(
                    'Edit'.tr(),
                    style: TextStyle(color: orangeColor),
                  ),
                  value: 'Edit',
                ),*/
                                                  PopupMenuItem(
                                                    child: Text(
                                                      'Delete'.tr(),
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    value: 'Delete',
                                                  ),
                                                ],
                                                onSelected: (newVal) async {
                                                  /* if (newVal == 'Edit') {
                  print(exerciseValue.id);
                  await Navigator.of(context)
                      .pushNamed('/EditExerciseView', arguments: {
                    // 'Categories IDs': exerciseValue.,
                    'name': exerciseValue.name,
                    'burn calories': exerciseValue.burn_calories,
                    'description': exerciseValue.desc,
                    'image': exerciseValue.exercise_img,
                    'id': exerciseValue.id,
                  });
                  Provider.of<GeneralChallengesViewModel>(context, listen: false)
                      .reset();
                  Provider.of<GeneralChallengesViewModel>(context, listen: false)
                      .getExercisesData(lang: getLang(context));
                } else */
                                                  if (newVal == 'Delete') {
                                                    print('yes');
                                                    final ChallengeModel
                                                        BackEndMessage =
                                                        await Provider.of<
                                                                    GeneralChallengesViewModel>(
                                                                context,
                                                                listen: false)
                                                            .deleteSpecificChallengeData(
                                                                context.locale ==
                                                                        Locale(
                                                                            'en')
                                                                    ? 'en'
                                                                    : 'ar',
                                                                // 2
                                                                challengeValue
                                                                    .id);

                                                    if (BackEndMessage
                                                                .message !=
                                                            '' ||
                                                        BackEndMessage
                                                                .message !=
                                                            '') {
                                                      showSnackbar(
                                                          Text(BackEndMessage
                                                              .message
                                                              .toString()),
                                                          context);
                                                    }
                                                    if (BackEndMessage
                                                            .statusCode ==
                                                        200) {
                                                      Provider.of<GeneralChallengesViewModel>(
                                                              context,
                                                              listen: false)
                                                          .reset();
                                                      Provider.of<GeneralChallengesViewModel>(
                                                              context,
                                                              listen: false)
                                                          .getData(
                                                              context.locale ==
                                                                      Locale(
                                                                          'en')
                                                                  ? 'en'
                                                                  : 'ar',
                                                              Provider.of<GeneralChallengesViewModel>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .page,
                                                              'out');
                                                    }
                                                  }
                                                },
                                              ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (challengeValue.is_sub!) {
                                              print(challengeValue.ex_id);
                                              if (challengeValue.ex_id
                                                      ?.toInt() ==
                                                  3) {
                                                buildDialog(
                                                    context, challengeValue);
                                              } else {
                                                await Navigator.pushNamed(
                                                    context,
                                                    '/specificChallenge',
                                                    arguments: {
                                                      'id': challengeValue.id,
                                                      'sensor': false,
                                                      'count': challengeValue
                                                          .total_count
                                                    });
                                              }
                                              Provider.of<GeneralChallengesViewModel>(
                                                      context,
                                                      listen: false)
                                                  .reset();
                                              Provider.of<GeneralChallengesViewModel>(
                                                      context,
                                                      listen: false)
                                                  .getData(
                                                      context.locale ==
                                                              Locale('en')
                                                          ? 'en'
                                                          : 'ar',
                                                      Provider.of<GeneralChallengesViewModel>(
                                                              context,
                                                              listen: false)
                                                          .page,
                                                      'out');
                                            } else {
                                              showSnackbar(
                                                  Text('Please! Subscribe before')
                                                      .tr(),
                                                  context);
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: mq.size.width * 0.3,
                                                height: mq.size.height * 0.2,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image(
                                                    loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) =>
                                                        loadingProgress != null
                                                            ? const LoadingContainer()
                                                            : child,
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                      "$ip/${challengeValue.img.toString()}", //TODO:
                                                      // 'https://media.istockphoto.com/photos/various-sport-equipments-on-grass-picture-id949190756?s=612x612',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(challengeValue.name
                                                        .toString()),
                                                    SizedBox(
                                                      height:
                                                          mq.size.height * 0.01,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 6),
                                                      child: Container(
                                                        child: Text(
                                                          challengeValue.desc
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: blueColor),
                                                          overflow:
                                                              TextOverflow.fade,
                                                          maxLines: 5,
                                                          // softWrap: false,
                                                          // textAlign: TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          mq.size.height * 0.01,
                                                    ),
                                                    Text(
                                                        '${challengeValue.total_count} / ${challengeValue.my_count}'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                challengeValue.sub_count
                                                        .toString() +
                                                    ' participants',
                                                style: TextStyle(
                                                    color: blueColor,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  final ChallengeModel
                                                      BackEndMessage =
                                                      await Provider.of<
                                                                  GeneralChallengesViewModel>(
                                                              context,
                                                              listen: false)
                                                          .sendParticipate(
                                                              context.locale ==
                                                                      Locale(
                                                                          'en')
                                                                  ? 'en'
                                                                  : 'ar',
                                                              // 2
                                                              challengeValue
                                                                  .id);

                                                  if (BackEndMessage.message !=
                                                          '' ||
                                                      BackEndMessage.message !=
                                                          '') {
                                                    showSnackbar(
                                                        Text(BackEndMessage
                                                            .message
                                                            .toString()),
                                                        context);
                                                  }
                                                  if (BackEndMessage
                                                          .statusCode ==
                                                      200) {
                                                    Provider.of<GeneralChallengesViewModel>(
                                                            context,
                                                            listen: false)
                                                        .reset();
                                                    Provider.of<GeneralChallengesViewModel>(
                                                            context,
                                                            listen: false)
                                                        .getData(
                                                            context.locale ==
                                                                    Locale('en')
                                                                ? 'en'
                                                                : 'ar',
                                                            Provider.of<GeneralChallengesViewModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .page,
                                                            'out');
                                                  }
                                                },
                                                child: Text(
                                                  challengeValue.is_sub!
                                                      ? 'Unsubscribe'
                                                      : 'Subscribe',
                                                ).tr())
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )))
                            .toList(),
                      );

                    case 'Workouts':
                      if (search.getWorkouts.isEmpty)
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mq.size.width * 0.5),
                            child: Text(
                              'There are no search results',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: greyColor),
                            ).tr(),
                          ),
                        );
                      return Column(
                        children: search.getWorkouts.map((workoutValue) {
                          return Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/anotherUserProfile',
                                            arguments: {
                                              'id': workoutValue.user_id
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  workoutValue.prof_img_url
                                                              .toString()
                                                              .substring(
                                                                  0, 4) !=
                                                          'http'
                                                      ? '$ip/${workoutValue.prof_img_url}'
                                                      : workoutValue
                                                          .prof_img_url
                                                          .toString()
                                                  // 'https://media.istockphoto.com/photos/various-sport-equipments-on-grass-picture-id949190756?s=612x612',
                                                  ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${workoutValue.f_name} ${workoutValue.l_name}',
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(color: blueColor),
                                              ),
                                              Text(
                                                '${workoutValue.created_at}',
                                                style: theme
                                                    .textTheme.displaySmall!
                                                    .copyWith(
                                                        color: greyColor,
                                                        fontSize: 10),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    // PopupMenuButton(
                                    //   itemBuilder: (context) => [
                                    //     PopupMenuItem(
                                    //       value: 'Favorite',
                                    //       child: Text(
                                    //         workoutValue.saved != true
                                    //             ? 'Add to favorite'.tr()
                                    //             : 'Delete from favorite'.tr(),
                                    //         style:
                                    //             TextStyle(color: orangeColor),
                                    //       ),
                                    //     ),
                                    //     if ((sharedPreferences.get("role_id") ==
                                    //             2) ||
                                    //         sharedPreferences.get("role_id") ==
                                    //             4 ||
                                    //         sharedPreferences.get("role_id") ==
                                    //             5)
                                    //       PopupMenuItem(
                                    //         child: Text(
                                    //           'Edit'.tr(),
                                    //           style:
                                    //               TextStyle(color: orangeColor),
                                    //         ),
                                    //         value: 'Edit',
                                    //       ),
                                    //     if ((sharedPreferences.get("role_id") ==
                                    //             2) ||
                                    //         sharedPreferences.get("role_id") ==
                                    //             4 ||
                                    //         sharedPreferences.get("role_id") ==
                                    //             5)
                                    //       PopupMenuItem(
                                    //         child: Text(
                                    //           'Delete'.tr(),
                                    //           style:
                                    //               TextStyle(color: Colors.red),
                                    //         ),
                                    //         value: 'Delete',
                                    //       ),
                                    //   ],
                                    //   onSelected: (newVal) async {
                                    //     if (newVal == 'Favorite') {
                                    //       final WorkoutListModel?
                                    //           BackEndMessage = await Provider
                                    //                   .of<WorkoutListViewModel>(
                                    //                       context,
                                    //                       listen: false)
                                    //               .changeFavoriteState(
                                    //                   context.locale ==
                                    //                           Locale('en')
                                    //                       ? 'en'
                                    //                       : 'ar',
                                    //                   workoutValue.id!.toInt());
                                    //       if (BackEndMessage!.message != '' ||
                                    //           BackEndMessage.message != '') {
                                    //         showSnackbar(
                                    //             Text(BackEndMessage.message
                                    //                 .toString()),
                                    //             context);
                                    //       }
                                    //       if (BackEndMessage.statusCode ==
                                    //           200) {
                                    //         Provider.of<WorkoutListViewModel>(
                                    //                 context,
                                    //                 listen: false)
                                    //             .resetForFilter();
                                    //         Provider.of<
                                    //                     WorkoutListViewModel>(
                                    //                 context,
                                    //                 listen: false)
                                    //             .getWorkoutsData(
                                    //                 context.locale ==
                                    //                         Locale('en')
                                    //                     ? 'en'
                                    //                     : 'ar',
                                    //                 Provider.of<WorkoutListViewModel>(
                                    //                         context,
                                    //                         listen: false)
                                    //                     .page,
                                    //                 Provider.of<WorkoutListViewModel>(
                                    //                         context,
                                    //                         listen: false)
                                    //                     .CategoryNumber,
                                    //                 Provider.of<WorkoutListViewModel>(
                                    //                         context,
                                    //                         listen: false)
                                    //                     .DifficultyNumber,
                                    //                 '/workout/filter');
                                    //       }
                                    //     } else if (newVal == 'Edit') {
                                    //       print('workoutValue.description');
                                    //       print(workoutValue.description);
                                    //       await Navigator.of(context).pushNamed(
                                    //           '/editWorkout',
                                    //           arguments: {
                                    //             // 'Categories IDs': workoutValue.,
                                    //             'name': workoutValue.name,
                                    //             'description':
                                    //                 workoutValue.description,
                                    //             'id': workoutValue.id,
                                    //             'categorie_name':
                                    //                 workoutValue.categorie_name,
                                    //           });
                                    //       Provider.of<WorkoutListViewModel>(
                                    //               context,
                                    //               listen: false)
                                    //           .resetForFilter();
                                    //       Provider.of<WorkoutListViewModel>(
                                    //               context,
                                    //               listen: false)
                                    //           .getWorkoutsData(
                                    //               context.locale == Locale('en')
                                    //                   ? 'en'
                                    //                   : 'ar',
                                    //               Provider.of<WorkoutListViewModel>(
                                    //                       context,
                                    //                       listen: false)
                                    //                   .page,
                                    //               Provider.of<WorkoutListViewModel>(
                                    //                       context,
                                    //                       listen: false)
                                    //                   .CategoryNumber,
                                    //               Provider.of<WorkoutListViewModel>(
                                    //                       context,
                                    //                       listen: false)
                                    //                   .DifficultyNumber,
                                    //               '/workout/filter');
                                    //     } else if (newVal == 'Delete') {
                                    //       print('yes');
                                    //       final WorkoutListModel
                                    //           BackEndMessage = await Provider
                                    //                   .of<WorkoutListViewModel>(
                                    //                       context,
                                    //                       listen: false)
                                    //               .deleteSpecificWorkout(
                                    //                   context.locale ==
                                    //                           Locale('en')
                                    //                       ? 'en'
                                    //                       : 'ar',
                                    //                   workoutValue.id);
                                    //       if (BackEndMessage.message != '' ||
                                    //           BackEndMessage.message != '') {
                                    //         showSnackbar(
                                    //             Text(BackEndMessage.message
                                    //                 .toString()),
                                    //             context);
                                    //       }
                                    //       if (BackEndMessage.statusCode ==
                                    //           200) {
                                    //         Provider.of<WorkoutListViewModel>(
                                    //                 context,
                                    //                 listen: false)
                                    //             .resetForFilter();
                                    //         Provider.of<
                                    //                     WorkoutListViewModel>(
                                    //                 context,
                                    //                 listen: false)
                                    //             .getWorkoutsData(
                                    //                 context.locale ==
                                    //                         Locale('en')
                                    //                     ? 'en'
                                    //                     : 'ar',
                                    //                 Provider.of<WorkoutListViewModel>(
                                    //                         context,
                                    //                         listen: false)
                                    //                     .page,
                                    //                 Provider.of<WorkoutListViewModel>(
                                    //                         context,
                                    //                         listen: false)
                                    //                     .CategoryNumber,
                                    //                 Provider.of<WorkoutListViewModel>(
                                    //                         context,
                                    //                         listen: false)
                                    //                     .DifficultyNumber,
                                    //                 '/workout/filter');
                                    //       }
                                    //     }
                                    //   },
                                    // ),
                                  ]),
                              InkWell(
                                onTap: () {
                                  log('ssss');
                                  Navigator.pushNamed(
                                      context, '/specificWorkout', arguments: {
                                    'workoutId': workoutValue.id
                                  });
                                  //TODO:
                                  // Navigator.pushNamed(context, '/specificWorkout',
                                  //     arguments: {'workoutId': workoutValue.id});
                                },
                                child: Container(
                                  width: mq.size.width * 0.95,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(17),
                                    border:
                                        Border.all(color: blueColor, width: 2),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image(
                                          loadingBuilder: (context, child,
                                                  loadingProgress) =>
                                              loadingProgress != null
                                                  ? const LoadingContainer()
                                                  : child,
                                          width: mq.size.width * 0.95,
                                          height: 250,
                                          fit: BoxFit.cover,
                                          image: NetworkImage(workoutValue
                                                          .workout_image_url
                                                          .toString()
                                                          .substring(0, 4) !=
                                                      'http'
                                                  ? '$ip/${workoutValue.workout_image_url}'
                                                  : workoutValue
                                                      .workout_image_url
                                                      .toString()
                                              // 'https://media.istockphoto.com/photos/various-sport-equipments-on-grass-picture-id949190756?s=612x612',
                                              ),
                                        ),
                                      ),
                                      Container(
                                        width: mq.size.width * 0.95,
                                        height: 250,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.65),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(15),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                15)),
                                                color: orangeColor
                                                    .withOpacity(0.5),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    FittedBox(
                                                      child: Text(
                                                          workoutValue.name
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: blueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 25)),
                                                    ),
                                                    FittedBox(
                                                      child: Text(
                                                        '$exer ${workoutValue.excersise_count}',
                                                        style: theme.textTheme
                                                            .displaySmall,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        const Icon(
                                                          Icons.alarm,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ),
                                                        Text(
                                                          '${workoutValue.length} $min',
                                                          style: theme.textTheme
                                                              .displaySmall!
                                                              .copyWith(
                                                                  fontSize: 15),
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
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(
                                                                15)),
                                                color: orangeColor
                                                    .withOpacity(0.5),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    FittedBox(
                                                      child: Text(
                                                        ' ',
                                                        style: theme.textTheme
                                                            .displaySmall,
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Text(
                                                        '${workoutValue.predicted_burnt_calories} $kcal',
                                                        style: theme.textTheme
                                                            .displaySmall,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .electric_bolt_rounded,
                                                      color: workoutValue
                                                                  .difficulty ==
                                                              1
                                                          ? Colors.green
                                                          : (workoutValue
                                                                      .difficulty ==
                                                                  2
                                                              ? Colors.yellow
                                                              : Colors.red),
                                                      size: 25,
                                                    ),
                                                    FittedBox(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 6),
                                                        child: Text(
                                                          workoutValue
                                                              .description
                                                              .toString(),
                                                          style: theme.textTheme
                                                              .displaySmall,
                                                          overflow:
                                                              TextOverflow.fade,
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

                              //Review
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          child: RatingBarIndicator(
                                            rating: workoutValue.rating ?? 0,
                                            itemSize: 25,
                                            itemCount: 5,
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          )),
                                      Text(
                                        workoutValue.rating.toString(),
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(color: greyColor),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/comments',
                                          arguments: {
                                            'id': workoutValue.id,
                                            'isWorkout': true,
                                            'isReviewd': workoutValue.reviewd,
                                          });
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Comments',
                                          style: theme.textTheme.bodySmall,
                                        ).tr(),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 15,
                                          color: orangeColor,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              // if (Provider.of<ProfileViewModel>(context,
                              //                 listen: true)
                              //             .getUserData
                              //             .id !=
                              //         workoutValue.user_id &&
                              //     workoutValue.reviewd == false)
                              //   Center(
                              //     child: Consumer<WorkoutListViewModel>(
                              //       builder: (context, review, child) => review
                              //               .getIsREviewLoading
                              //           ? Padding(
                              //               padding: const EdgeInsets.all(8.0),
                              //               child:
                              //                   bigLoader(color: orangeColor),
                              //             )
                              //           : TextButton(
                              //               onPressed: () {
                              //                 showDialog(
                              //                     context: context,
                              //                     builder: (BuildContext ctx) {
                              //                       _reviewController.clear();
                              //                       double stars = 0;
                              //                       return AlertDialog(
                              //                         shape:
                              //                             RoundedRectangleBorder(
                              //                                 borderRadius:
                              //                                     BorderRadius
                              //                                         .circular(
                              //                                             15)),
                              //                         content: Container(
                              //                             height: 240,
                              //                             child: Column(
                              //                               children: [
                              //                                 RatingBar.builder(
                              //                                   itemCount: 5,
                              //                                   allowHalfRating:
                              //                                       true,
                              //                                   unratedColor:
                              //                                       greyColor,
                              //                                   //initialRating: e.rating,
                              //                                   maxRating: 5,
                              //                                   itemBuilder: (context,
                              //                                           index) =>
                              //                                       const Icon(
                              //                                     Icons.star,
                              //                                     color: Colors
                              //                                         .amber,
                              //                                   ),
                              //                                   onRatingUpdate:
                              //                                       (value) {
                              //                                     stars = value;
                              //                                     return;
                              //                                   },
                              //                                 ),
                              //                                 Padding(
                              //                                   padding:
                              //                                       const EdgeInsets
                              //                                               .all(
                              //                                           8.0),
                              //                                   child: CustomTextField(
                              //                                       maxLines: 5,
                              //                                       controller:
                              //                                           _reviewController,
                              //                                       title:
                              //                                           'Comment'),
                              //                                 ),
                              //                                 ElevatedButton(
                              //                                     onPressed:
                              //                                         () async {
                              //                                       Navigator
                              //                                           .pop(
                              //                                               ctx);
                              //                                       final response = await review.sendReview(
                              //                                           lang: getLang(
                              //                                               context),
                              //                                           id: workoutValue.id ??
                              //                                               0,
                              //                                           review: _reviewController
                              //                                               .text
                              //                                               .trim(),
                              //                                           stars:
                              //                                               stars,
                              //                                           context:
                              //                                               context);
                              //                                       if (response) {
                              //                                         setState(
                              //                                             () {
                              //                                           workoutValue.reviewd =
                              //                                               true;
                              //                                         });
                              //                                       }
                              //                                       _reviewController
                              //                                           .clear();
                              //                                     },
                              //                                     child: const Text(
                              //                                         'Submit')),
                              //                               ],
                              //                             )),
                              //                       );
                              //                     });
                              //               },
                              //               child: Text(
                              //                 'Add a review',
                              //                 style: theme.textTheme.bodySmall!
                              //                     .copyWith(
                              //                         color: Colors.amber),
                              //               ),
                              //             ),
                              //     ),
                              //   ),
                              // Divider(
                              //   endIndent: 50,
                              //   indent: 50,
                              //   color: blueColor,
                              // ),
                            ],
                          );
                        }).toList(),
                      );

                      break;

                    default:
                      return const Text('');
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buildDialog(BuildContext Bcontext, ChallengeModel challengeValue) {
    final alert = AlertDialog(
      title: Text(
        'Exercise type',
        style: TextStyle(color: blueColor),
      ).tr(),
      content: Container(
        height: 150,
        child: Column(
          children: [
            Divider(),
            TextButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed('/specificChallenge',
                    arguments: {
                      'id': challengeValue.id,
                      'sensor': true,
                      'count': challengeValue.total_count
                    });
                Navigator.of(context).pop();
                Provider.of<GeneralChallengesViewModel>(context, listen: false)
                    .reset();
                Provider.of<GeneralChallengesViewModel>(context, listen: false)
                    .getData(
                        context.locale == Locale('en') ? 'en' : 'ar',
                        Provider.of<GeneralChallengesViewModel>(context,
                                listen: false)
                            .page,
                        'out');
              },
              child: Text(
                'With sensor',
                style: TextStyle(color: orangeColor),
              ).tr(),
            ),
            SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed('/specificChallenge',
                    arguments: {
                      'id': challengeValue.id,
                      'sensor': false,
                      'count': challengeValue.total_count
                    });
                Navigator.of(context).pop();
                Provider.of<GeneralChallengesViewModel>(context, listen: false)
                    .reset();
                Provider.of<GeneralChallengesViewModel>(context, listen: false)
                    .getData(
                        context.locale == Locale('en') ? 'en' : 'ar',
                        Provider.of<GeneralChallengesViewModel>(context,
                                listen: false)
                            .page,
                        'out');
              },
              child: Text(
                'Without sensor',
                style: TextStyle(color: orangeColor),
              ).tr(),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: orangeColor.withOpacity(0.1),
        builder: (BuildContext ctx) {
          return alert;
        });
  }
}
