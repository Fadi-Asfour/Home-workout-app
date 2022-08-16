import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/workout_list_model.dart';
import 'package:home_workout_app/view_models/Workout_View_Model/favorite_workouts_view_model.dart';
import 'package:home_workout_app/view_models/Workout_View_Model/my_workouts_view_model.dart';
import 'package:home_workout_app/views/Home%20View/home_view_widgets.dart';
import 'package:provider/provider.dart';

import '../../view_models/Workout_View_Model/workout_list_view_model.dart';
import '../../view_models/profile_view_model.dart';
import '../Posts View/post_view_widgets.dart';

class favoriteWorkoutsView extends StatefulWidget {
  const favoriteWorkoutsView({Key? key}) : super(key: key);

  @override
  State<favoriteWorkoutsView> createState() => _favoriteWorkoutsViewState();
}

class _favoriteWorkoutsViewState extends State<favoriteWorkoutsView> {
  final ListViewController = ScrollController();
  TextEditingController _reviewController = TextEditingController();
  String exer = 'Exercises:'.tr();
  String min = 'min'.tr();
  String kcal = 'Kcal'.tr();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<favoriteWorkoutsViewModel>(context, listen: false).reset();
      Provider.of<favoriteWorkoutsViewModel>(context, listen: false)
          .getWorkoutsData(
              getLang(context),
              Provider.of<favoriteWorkoutsViewModel>(context, listen: false)
                  .page,
              '/workout/favorites');
      print('ccccccccccccccccccccccccccc');
      ListViewController.addListener(() {
        if (ListViewController.position.maxScrollExtent ==
            ListViewController.offset) {
          Provider.of<favoriteWorkoutsViewModel>(context, listen: false)
              .setIsLoading(true);
          Provider.of<favoriteWorkoutsViewModel>(context, listen: false)
              .getWorkoutsData(
                  getLang(context),
                  Provider.of<favoriteWorkoutsViewModel>(context, listen: false)
                      .page,
                  '/workout/favorites');
          // print(object)
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    var role_id = sharedPreferences.getInt("role_id");
    return SafeArea(
      child: Scaffold(
        // floatingActionButton: (role_id == 2 || role_id == 4 || role_id == 5)
        //     ? FloatingActionButton(
        //         onPressed: () {
        //           buildDialog(context);
        //         },
        //         child: Icon(Icons.add),
        //       )
        //     : Container(),
        appBar: AppBar(
          title: Text(
            'Favorite workouts',
            style: theme.textTheme.bodyMedium!,
          ).tr(),
        ),
        body: Container(
            child: Column(
          children: [
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Consumer<MobileHomeViewModel>(
            //     builder: (context, consumer, child) => Row(
            //       children: consumer.categories.entries
            //           .map(
            //             (e) => InkWell(
            //               onTap: () {
            //                 consumer.changeSelectedCategorie(e.key, true);
            //               },
            //               child: Container(
            //                 margin: const EdgeInsets.all(4),
            //                 padding: const EdgeInsets.all(7),
            //                 decoration: BoxDecoration(
            //                     color: e.value ? blueColor : greyColor,
            //                     borderRadius: BorderRadius.circular(15)),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(4),
            //                   child: Text(
            //                     e.key,
            //                     style: theme.textTheme.bodySmall!.copyWith(
            //                         color: Colors.white,
            //                         fontSize: e.value ? 15 : 10),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           )
            //           .toList(),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Consumer<favoriteWorkoutsViewModel>(
                builder: ((context, value, _) => (Provider.of<
                            favoriteWorkoutsViewModel>(context, listen: true)
                        .getfutureworkoutsList!
                        .isEmpty
                    ? bigLoader(color: orangeColor)
                    : RefreshIndicator(
                        onRefresh: () async {
                          Provider.of<favoriteWorkoutsViewModel>(context,
                                  listen: false)
                              .reset();
                          Provider.of<favoriteWorkoutsViewModel>(context,
                                  listen: false)
                              .getWorkoutsData(
                                  context.locale == Locale('en') ? 'en' : 'ar',
                                  Provider.of<favoriteWorkoutsViewModel>(
                                          context,
                                          listen: false)
                                      .page,
                                  '/workout/favorites');
                        },
                        child: ListView.builder(
                          controller: ListViewController,
                          physics: AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          // scrollDirection: Axis.horizontal,
                          itemCount: value.getfutureworkoutsList?.length,
                          itemBuilder: ((context, index) {
                            if (index < value.getfutureworkoutsList!.length) {
                              final item = value.getfutureworkoutsList![index];
                              // return ListTile(title: Text(item));
                              return _buildList(context, index,
                                  value.getfutureworkoutsList![index]);
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                        ),
                      ))),
              ),
            ),
            Provider.of<favoriteWorkoutsViewModel>(context, listen: true)
                        .isLoading ==
                    true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: bigLoader(color: orangeColor),
                  )
                : Container(),
          ],
        )),
      ),
    );
  }

  /* void buildDialog(BuildContext context) {
    final alert = AlertDialog(
      title: Text(
        'Create type',
        style: TextStyle(color: blueColor),
      ),
      content: Container(
        height: 150,
        child: Column(
          children: [
            Divider(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  '/createExercise',
                );
              },
              child: Text(
                'Create exercise',
                style: TextStyle(color: orangeColor),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  '/createWorkout',
                );
              },
              child: Text(
                'Create workout',
                style: TextStyle(color: orangeColor),
              ),
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
*/
  _buildList(BuildContext context, int index, WorkoutListModel workoutValue) {
    final mq = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                      backgroundImage: NetworkImage(workoutValue.prof_img_url
                                      .toString()
                                      .substring(0, 4) !=
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
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: blueColor),
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
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'Favorite',
                  child: Text(
                    workoutValue.saved != true
                        ? 'Add to favorite'.tr()
                        : 'Delete from favorite'.tr(),
                    style: TextStyle(color: orangeColor),
                  ),
                ),
                if ((sharedPreferences.get("role_id") == 2 &&
                        Provider.of<ProfileViewModel>(context, listen: false)
                                .getUserData
                                .id ==
                            workoutValue.user_id) ||
                    sharedPreferences.get("role_id") == 4 ||
                    sharedPreferences.get("role_id") == 5)
                  PopupMenuItem(
                    child: Text(
                      'Edit'.tr(),
                      style: TextStyle(color: orangeColor),
                    ),
                    value: 'Edit',
                  ),
                if ((sharedPreferences.get("role_id") == 2 &&
                        Provider.of<ProfileViewModel>(context, listen: false)
                                .getUserData
                                .id ==
                            workoutValue.user_id) ||
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
                      await Provider.of<favoriteWorkoutsViewModel>(context,
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
                    Provider.of<favoriteWorkoutsViewModel>(context,
                            listen: false)
                        .reset();
                    Provider.of<favoriteWorkoutsViewModel>(context,
                            listen: false)
                        .getWorkoutsData(
                            getLang(context),
                            Provider.of<favoriteWorkoutsViewModel>(context,
                                    listen: false)
                                .page,
                            '/workout/favorites');
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
                  Provider.of<favoriteWorkoutsViewModel>(context, listen: false)
                      .reset();
                  Provider.of<favoriteWorkoutsViewModel>(context, listen: false)
                      .getWorkoutsData(
                          getLang(context),
                          Provider.of<favoriteWorkoutsViewModel>(context,
                                  listen: false)
                              .page,
                          '/workout/favorites');
                } else if (newVal == 'Delete') {
                  print('yes');
                  final WorkoutListModel BackEndMessage =
                      await Provider.of<favoriteWorkoutsViewModel>(context,
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
                    Provider.of<favoriteWorkoutsViewModel>(context,
                            listen: false)
                        .reset();
                    Provider.of<favoriteWorkoutsViewModel>(context,
                            listen: false)
                        .getWorkoutsData(
                            getLang(context),
                            Provider.of<favoriteWorkoutsViewModel>(context,
                                    listen: false)
                                .page,
                            '/workout/favorites');
                  }
                }
              },
            ),
          ],
        ),
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
                              // FittedBox(
                              //   child: Text(
                              //     ' ',
                              //     style: theme.textTheme.displaySmall,
                              //   ),
                              // ),
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

        //Review

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    )),
                Text(
                  workoutValue.rating.toString(),
                  style: theme.textTheme.bodySmall!.copyWith(color: greyColor),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/comments', arguments: {
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
        if (Provider.of<ProfileViewModel>(context, listen: true)
                    .getUserData
                    .id !=
                workoutValue.user_id &&
            workoutValue.reviewd == false)
          Center(
            child: Consumer<WorkoutListViewModel>(
              builder: (context, review, child) => review.getIsREviewLoading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: bigLoader(color: orangeColor),
                    )
                  : TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              _reviewController.clear();
                              double stars = 0;
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
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
                                          itemBuilder: (context, index) =>
                                              const Icon(
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
                                          child: CustomTextField(
                                              maxLines: 5,
                                              controller: _reviewController,
                                              title: 'Comment'),
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(ctx);
                                              final response =
                                                  await review.sendReview(
                                                      lang: getLang(context),
                                                      id: workoutValue.id ?? 0,
                                                      review: _reviewController
                                                          .text
                                                          .trim(),
                                                      stars: stars,
                                                      context: context);
                                              if (response) {
                                                setState(() {
                                                  workoutValue.reviewd = true;
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
                      child: Text(
                        'Add a review',
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: Colors.amber),
                      ),
                    ),
            ),
          ),
        Divider(
          endIndent: 50,
          indent: 50,
          color: blueColor,
        ),
      ],
    );
  }
}
