// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/comments_model.dart';
import 'package:home_workout_app/view_models/Workout_View_Model/workout_list_view_model.dart';
import 'package:home_workout_app/view_models/comments_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../view_models/Diet View Model/Diet/diet_list_view_model.dart';

class CommentsView extends StatefulWidget {
  CommentsView({Key? key}) : super(key: key);

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  @override
  ScrollController _scrollController = ScrollController();
  int postId = 0;
  int dietId = 0;
  int workoutId = 0;
  bool isReviewd = false;
  bool isWorkout = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      if (args['review'] != null) {
        setState(() {
          isReview = true;
          isReviewd = args['isReviewd'] ?? false;
          dietId = args['id'] ?? 0;
        });

        Provider.of<CommentsViewModel>(context, listen: false).resetComments();
        Provider.of<CommentsViewModel>(context, listen: false).setPage(0);
        Provider.of<CommentsViewModel>(context, listen: false).setReviews(
            id: dietId,
            lang: context.locale == const Locale('en') ? 'en' : 'ar');
        _scrollController.addListener(() {
          if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent) {
            Provider.of<CommentsViewModel>(context, listen: false).setReviews(
                id: dietId,
                lang: context.locale == const Locale('en') ? 'en' : 'ar');
          }
        });
      } else if (args['isWorkout'] != null) {
        setState(() {
          isWorkout = true;
          isReviewd = args['isReviewd'] ?? false;
          workoutId = args['id'] ?? 0;
        });

        Provider.of<CommentsViewModel>(context, listen: false).resetComments();
        Provider.of<CommentsViewModel>(context, listen: false).setPage(0);
        Provider.of<CommentsViewModel>(context, listen: false)
            .setReviewsForWorkout(
                id: workoutId,
                lang: context.locale == const Locale('en') ? 'en' : 'ar');
        _scrollController.addListener(() {
          if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent) {
            Provider.of<CommentsViewModel>(context, listen: false)
                .setReviewsForWorkout(
                    id: workoutId,
                    lang: context.locale == const Locale('en') ? 'en' : 'ar');
          }
        });
      } else {
        postId = args['id'] ?? 0;
        Provider.of<CommentsViewModel>(context, listen: false).resetComments();
        Provider.of<CommentsViewModel>(context, listen: false).setPage(0);
        Provider.of<CommentsViewModel>(context, listen: false).setComments(
            id: postId,
            lang: context.locale == const Locale('en') ? 'en' : 'ar');
        _scrollController.addListener(() {
          if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent) {
            Provider.of<CommentsViewModel>(context, listen: false).setComments(
                id: postId,
                lang: context.locale == const Locale('en') ? 'en' : 'ar');
          }
        });
      }
    });
  }

  bool isReview = false;

  TextEditingController commentsController = TextEditingController();
  TextEditingController editCommentsController = TextEditingController();
  TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: isReview || isWorkout
          ? Container(
              height: 50,
              child: isReviewd
                  ? null
                  : Center(
                      child: Consumer2<DietListViewModel, WorkoutListViewModel>(
                          builder: (context, review, workoutReview, child) => review
                                  .getIsREviewLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: bigLoader(color: orangeColor),
                                )
                              : (isReview &&
                                          Provider.of<ProfileViewModel>(context,
                                                      listen: true)
                                                  .getUserData
                                                  .id ==
                                              review.getDiets
                                                  .firstWhere((element) =>
                                                      element.id == dietId)
                                                  .userId ||
                                      (isWorkout &&
                                              workoutReview
                                                  .workoutsList!.isNotEmpty &&
                                              Provider.of<ProfileViewModel>(
                                                          context,
                                                          listen: true)
                                                      .getUserData
                                                      .id ==
                                                  workoutReview.workoutsList!
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          workoutId)
                                                      .user_id ||
                                          isWorkout)
                                  ? const Text('')
                                  : TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext ctx) {
                                              double stars = 0;
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                content: Container(
                                                    height: 240,
                                                    child: Column(
                                                      children: [
                                                        RatingBar.builder(
                                                          itemCount: 5,
                                                          allowHalfRating: true,
                                                          unratedColor:
                                                              greyColor,
                                                          //initialRating: e.rating,
                                                          maxRating: 5,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          onRatingUpdate:
                                                              (value) {
                                                            stars = value;
                                                            return;
                                                          },
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: CustomTextField(
                                                              maxLines: 5,
                                                              controller:
                                                                  _reviewController,
                                                              title: 'Comment'),
                                                        ),
                                                        ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              final response;
                                                              Navigator.pop(
                                                                  ctx);
                                                              if (isReview) {
                                                                response = await review.sendReview(
                                                                    lang: getLang(
                                                                        context),
                                                                    id: dietId,
                                                                    review: _reviewController
                                                                        .text
                                                                        .trim(),
                                                                    stars:
                                                                        stars,
                                                                    context:
                                                                        context);
                                                              } else {
                                                                response = await workoutReview.sendReview(
                                                                    lang: getLang(
                                                                        context),
                                                                    id:
                                                                        workoutId,
                                                                    review: _reviewController
                                                                        .text
                                                                        .trim(),
                                                                    stars:
                                                                        stars,
                                                                    context:
                                                                        context);
                                                              }
                                                              _reviewController
                                                                  .clear();
                                                              if (response) {
                                                                setState(() {
                                                                  isReviewd =
                                                                      true;
                                                                });
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
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(color: Colors.amber),
                                      ),
                                    ))),
                    ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isReview || isWorkout
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: orangeColor, width: 2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                          maxLines: 1,
                          controller: commentsController,
                          title: 'Type a comment...'),
                    ),
                    Consumer<CommentsViewModel>(
                      builder: (context, comments, child) =>
                          comments.getIsLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: bigLoader(color: orangeColor),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    if (commentsController.text.trim().isEmpty)
                                      return;
                                    await comments.sendComment(
                                        id: postId,
                                        lang:
                                            context.locale == const Locale('en')
                                                ? 'en'
                                                : 'ar',
                                        comment: commentsController.text.trim(),
                                        context: context);
                                    commentsController.clear();
                                  },
                                  icon: Icon(
                                    context.locale == const Locale('en')
                                        ? Icons.arrow_circle_right_outlined
                                        : Icons.arrow_circle_left_outlined,
                                    size: 30,
                                    color: orangeColor,
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Comments',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: Consumer<CommentsViewModel>(
          builder: (context, comments, child) => comments.getIsLoading
              ? Center(
                  child: bigLoader(color: orangeColor),
                )
              : (comments.getComments.isEmpty
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('There are no comments',
                                  style: theme.textTheme.bodySmall!
                                      .copyWith(color: greyColor))
                              .tr(),
                          TextButton(
                              onPressed: () async {
                                if (isReview) {
                                  Provider.of<CommentsViewModel>(context,
                                          listen: false)
                                      .resetComments();
                                  Provider.of<CommentsViewModel>(context,
                                          listen: false)
                                      .setPage(0);
                                  await Provider.of<CommentsViewModel>(context,
                                          listen: false)
                                      .setReviews(
                                          id: dietId,
                                          lang: context.locale ==
                                                  const Locale('en')
                                              ? 'en'
                                              : 'ar');
                                } else if (isWorkout) {
                                  log('hereeeee');
                                  Provider.of<CommentsViewModel>(context,
                                          listen: false)
                                      .resetComments();
                                  Provider.of<CommentsViewModel>(context,
                                          listen: false)
                                      .setPage(0);
                                  await Provider.of<CommentsViewModel>(context,
                                          listen: false)
                                      .setReviewsForWorkout(
                                          id: workoutId,
                                          lang: context.locale ==
                                                  const Locale('en')
                                              ? 'en'
                                              : 'ar');
                                } else {
                                  Provider.of<CommentsViewModel>(context,
                                          listen: false)
                                      .resetComments();
                                  Provider.of<CommentsViewModel>(context,
                                          listen: false)
                                      .setPage(0);
                                  await Provider.of<CommentsViewModel>(context,
                                          listen: false)
                                      .setComments(
                                          id: postId,
                                          lang: context.locale ==
                                                  const Locale('en')
                                              ? 'en'
                                              : 'ar');
                                }
                                log(Provider.of<ProfileViewModel>(context,
                                        listen: false)
                                    .getUserData
                                    .id
                                    .toString());
                              },
                              child: Text('Refresh',
                                      style: theme.textTheme.bodySmall)
                                  .tr())
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: orangeColor,
                      onRefresh: () async {
                        log(Provider.of<ProfileViewModel>(context,
                                listen: false)
                            .getUserData
                            .id
                            .toString());
                        if (isReview) {
                          Provider.of<CommentsViewModel>(context, listen: false)
                              .resetComments();
                          Provider.of<CommentsViewModel>(context, listen: false)
                              .setPage(0);
                          await Provider.of<CommentsViewModel>(context,
                                  listen: false)
                              .setReviews(
                                  id: dietId,
                                  lang: context.locale == const Locale('en')
                                      ? 'en'
                                      : 'ar');
                        } else if (isWorkout) {
                          Provider.of<CommentsViewModel>(context, listen: false)
                              .resetComments();
                          Provider.of<CommentsViewModel>(context, listen: false)
                              .setPage(0);
                          await Provider.of<CommentsViewModel>(context,
                                  listen: false)
                              .setReviewsForWorkout(
                                  id: workoutId,
                                  lang: context.locale == const Locale('en')
                                      ? 'en'
                                      : 'ar');
                        } else {
                          Provider.of<CommentsViewModel>(context, listen: false)
                              .resetComments();
                          Provider.of<CommentsViewModel>(context, listen: false)
                              .setPage(0);
                          await Provider.of<CommentsViewModel>(context,
                                  listen: false)
                              .setComments(
                                  id: postId,
                                  lang: context.locale == const Locale('en')
                                      ? 'en'
                                      : 'ar');
                        }
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              controller: _scrollController,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 110),
                                child: Column(
                                  children: comments.getComments
                                      .map(
                                        (e) => isReview || isWorkout
                                            ? Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          color: blueColor,
                                                          width: 2),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pushNamed(
                                                                        context,
                                                                        '/anotherUserProfile',
                                                                        arguments: {
                                                                          'id':
                                                                              e.ownerId
                                                                        });
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            CircleAvatar(
                                                                          backgroundImage:
                                                                              NetworkImage(e.ownerImageUrl),
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            e.owner,
                                                                            style:
                                                                                theme.textTheme.bodySmall!.copyWith(color: blueColor),
                                                                          ),
                                                                          Text(
                                                                            e.createdAt,
                                                                            style:
                                                                                theme.textTheme.displaySmall!.copyWith(color: greyColor, fontSize: 10),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            if (e.ownerId ==
                                                                Provider.of<ProfileViewModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getUserData
                                                                    .id)
                                                              Row(
                                                                children: [
                                                                  if (e.ownerId ==
                                                                      Provider.of<ProfileViewModel>(
                                                                              context,
                                                                              listen: false)
                                                                          .getUserData
                                                                          .id)
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        double
                                                                            stars =
                                                                            0;
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext ctx) =>
                                                                              AlertDialog(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  FocusScope.of(context).unfocus();
                                                                                  Navigator.pop(ctx);
                                                                                  editCommentsController.clear();
                                                                                },
                                                                                child: Text(
                                                                                  'Cancel',
                                                                                  style: theme.textTheme.bodySmall!.copyWith(color: greyColor),
                                                                                ).tr(),
                                                                              ),
                                                                              TextButton(
                                                                                onPressed: () async {
                                                                                  FocusScope.of(context).unfocus();
                                                                                  if (stars == 0) {
                                                                                    Navigator.pop(ctx);
                                                                                    showSnackbar(Text('Review stars cannot be 0').tr(), context);
                                                                                    return;
                                                                                  }
                                                                                  if (isReview) {
                                                                                    await comments.updateReview(
                                                                                      reviewId: e.id,
                                                                                      dietId: dietId,
                                                                                      stars: stars,
                                                                                      comment: editCommentsController.text.trim(),
                                                                                      lang: context.locale == const Locale('en') ? 'en' : 'ar',
                                                                                      context: context,
                                                                                    );
                                                                                  } else if (isWorkout) {
                                                                                    await comments.updateReviewForWorkout(
                                                                                      reviewId: e.id,
                                                                                      workoutId: workoutId,
                                                                                      stars: stars,
                                                                                      comment: editCommentsController.text.trim(),
                                                                                      lang: context.locale == const Locale('en') ? 'en' : 'ar',
                                                                                      context: context,
                                                                                    );
                                                                                  }

                                                                                  Navigator.pop(ctx);
                                                                                  editCommentsController.clear();
                                                                                },
                                                                                child: Text(
                                                                                  'Edit',
                                                                                  style: theme.textTheme.bodySmall!.copyWith(color: orangeColor),
                                                                                ).tr(),
                                                                              ),
                                                                            ],
                                                                            content:
                                                                                SizedBox(
                                                                              height: 110,
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
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  CustomTextField(maxLines: 1, controller: editCommentsController, title: 'Type a comment...'),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .edit,
                                                                        size:
                                                                            20,
                                                                        color:
                                                                            blueColor,
                                                                      ),
                                                                    ),
                                                                  if (e.ownerId ==
                                                                          Provider.of<ProfileViewModel>(context, listen: true)
                                                                              .getUserData
                                                                              .id ||
                                                                      Provider.of<ProfileViewModel>(context, listen: false)
                                                                              .getUserData
                                                                              .roleId ==
                                                                          4 ||
                                                                      Provider.of<ProfileViewModel>(context, listen: false)
                                                                              .getUserData
                                                                              .roleId ==
                                                                          5)
                                                                    comments
                                                                            .getdeleteIsLoading
                                                                        ? smallLoader(
                                                                            color:
                                                                                Colors.red)
                                                                        : IconButton(
                                                                            onPressed:
                                                                                () async {
                                                                              bool? response;
                                                                              if (isReview) {
                                                                                final response = await comments.deleteReview(reviewId: e.id, dietId: dietId, lang: context.locale == const Locale('en') ? 'en' : 'ar', context: context);
                                                                              } else if (isWorkout) {
                                                                                final response = await comments.deleteReviewForWorkout(reviewId: e.id, workoutId: workoutId, lang: context.locale == const Locale('en') ? 'en' : 'ar', context: context);
                                                                              }
                                                                              if (response ?? false)
                                                                                // ignore: curly_braces_in_flow_control_structures
                                                                                setState(() {
                                                                                  isReviewd = !isReviewd;
                                                                                });
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.delete,
                                                                              size: 20,
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 60),
                                                            child: Text(
                                                              e.comment,
                                                              style: theme
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                RatingBarIndicator(
                                                              itemBuilder: (context,
                                                                      index) =>
                                                                  const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              itemCount: 5,
                                                              itemSize: 30,
                                                              rating:
                                                                  e.reviewRate,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          color: blueColor,
                                                          width: 2),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    '/anotherUserProfile',
                                                                    arguments: {
                                                                      'id': e
                                                                          .ownerId
                                                                    });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              e.ownerImageUrl),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        e.owner,
                                                                        style: theme
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .copyWith(color: blueColor),
                                                                      ),
                                                                      Text(
                                                                        e.createdAt,
                                                                        style: theme
                                                                            .textTheme
                                                                            .displaySmall!
                                                                            .copyWith(
                                                                                color: greyColor,
                                                                                fontSize: 10),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            if (e.ownerId ==
                                                                    Provider.of<ProfileViewModel>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getUserData
                                                                        .id &&
                                                                !isReview)
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext ctx) =>
                                                                                AlertDialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                          ),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                FocusScope.of(context).unfocus();
                                                                                Navigator.pop(ctx);
                                                                                editCommentsController.clear();
                                                                              },
                                                                              child: Text(
                                                                                'Cancel',
                                                                                style: theme.textTheme.bodySmall!.copyWith(color: greyColor),
                                                                              ).tr(),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () async {
                                                                                FocusScope.of(context).unfocus();
                                                                                if (editCommentsController.text.trim().isEmpty) {
                                                                                  return;
                                                                                }

                                                                                await comments.updateComment(commentId: e.id, postId: postId, comment: editCommentsController.text.trim(), lang: context.locale == const Locale('en') ? 'en' : 'ar', context: context);
                                                                                Navigator.pop(ctx);
                                                                                editCommentsController.clear();
                                                                              },
                                                                              child: Text(
                                                                                'Edit',
                                                                                style: theme.textTheme.bodySmall!.copyWith(color: orangeColor),
                                                                              ).tr(),
                                                                            ),
                                                                          ],
                                                                          content:
                                                                              SizedBox(
                                                                            height:
                                                                                110,
                                                                            child: CustomTextField(
                                                                                maxLines: 1,
                                                                                controller: editCommentsController,
                                                                                title: 'Type a comment...'),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .edit,
                                                                      size: 20,
                                                                      color:
                                                                          blueColor,
                                                                    ),
                                                                  ),
                                                                  comments
                                                                          .getdeleteIsLoading
                                                                      ? smallLoader(
                                                                          color:
                                                                              Colors.red)
                                                                      : IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await comments.deleteComment(
                                                                                commentId: e.id,
                                                                                postId: postId,
                                                                                lang: context.locale == const Locale('en') ? 'en' : 'ar',
                                                                                context: context);
                                                                          },
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.delete,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            if (e.ownerId !=
                                                                Provider.of<ProfileViewModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getUserData
                                                                    .id)
                                                              (comments
                                                                      .getIsReportLoading
                                                                  ? smallLoader(
                                                                      color:
                                                                          orangeColor)
                                                                  : TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        comments.reportComment(
                                                                            commentId:
                                                                                e.id,
                                                                            lang: getLang(context),
                                                                            context: context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'report',
                                                                        style: theme
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .copyWith(color: Colors.red),
                                                                      ),
                                                                    ))
                                                          ],
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 60),
                                                            child: Text(
                                                              e.comment,
                                                              style: theme
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                color: Colors
                                                                    .black,
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
                            ),
                          ),
                          if (Provider.of<CommentsViewModel>(context,
                                  listen: true)
                              .getMoreLoading)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 110, top: 10),
                              child: bigLoader(color: orangeColor),
                            )
                        ],
                      ),
                    ))),
    );
  }
}
