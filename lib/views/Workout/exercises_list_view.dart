import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/exercise_model.dart';
import 'package:home_workout_app/view_models/Workout_View_Model/exercises_list_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';

import 'package:home_workout_app/views/Home%20View/home_view_widgets.dart';
import 'package:provider/provider.dart';

class ExercisesListView extends StatefulWidget {
  const ExercisesListView({Key? key}) : super(key: key);

  @override
  State<ExercisesListView> createState() => _ExercisesListViewState();
}

class _ExercisesListViewState extends State<ExercisesListView> {
  final ListViewController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<exercisesListViewModel>(context, listen: false).reset();
      Provider.of<exercisesListViewModel>(context, listen: false)
          .getExercisesData(lang: getLang(context));
      print('fffffffff]]]]]]]]');
      // print(Provider.of<exercisesListViewModel>(context, listen: false)
      //     .getIsFetched);
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
            'Exercises list'.tr(),
            style: theme.textTheme.bodyMedium!,
          ),
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
              child: Consumer<exercisesListViewModel>(
                builder: ((context, value, _) =>
                    (Provider.of<exercisesListViewModel>(context, listen: true)
                            .getexercisesList
                            .isEmpty
                        ? //bigLoader(color: orangeColor)
                        Container()
                        : ListView.builder(
                            // controller: ListViewController,
                            physics: BouncingScrollPhysics(),
                            // scrollDirection: Axis.horizontal,
                            itemCount: value.getexercisesList.length,
                            itemBuilder: ((context, index) {
                              if (index < value.getexercisesList.length) {
                                final item = value.getexercisesList[index];
                                // return ListTile(title: Text(item));
                                return _buildList(context, index,
                                    value.getexercisesList[index]);
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                          ))),
              ),
            ),
          ],
        )),
      ),
    );
  }

  // void buildDialog(BuildContext context) {
  //   final alert = AlertDialog(
  //     title: Text(
  //       'Create type',
  //       style: TextStyle(color: blueColor),
  //     ),
  //     content: Container(
  //       height: 150,
  //       child: Column(
  //         children: [
  //           Divider(),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pushNamed(
  //                 '/createExercise',
  //               );
  //             },
  //             child: Text(
  //               'Create exercise',
  //               style: TextStyle(color: orangeColor),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 15,
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pushNamed(
  //                 '/createWorkout',
  //               );
  //             },
  //             child: Text(
  //               'Create workout',
  //               style: TextStyle(color: orangeColor),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //   showDialog(
  //       context: context,
  //       barrierColor: orangeColor.withOpacity(0.1),
  //       builder: (BuildContext ctx) {
  //         return alert;
  //       });
  // }

  _buildList(BuildContext context, int index, exerciseModel exerciseValue) {
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
                    arguments: {'id': exerciseValue.user_id});
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(exerciseValue.prof_img_url
                                      .toString()
                                      .substring(0, 4) !=
                                  'http'
                              ? '$ip/${exerciseValue.prof_img_url}'
                              : exerciseValue.prof_img_url.toString()
                          // 'https://media.istockphoto.com/photos/various-sport-equipments-on-grass-picture-id949190756?s=612x612'
                          ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${exerciseValue.f_name} ${exerciseValue.l_name}',
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: blueColor),
                      ),
                      Text(
                        // '6/3/2022 - 5:33 PM',
                        '${exerciseValue.created_at}',
                        style: theme.textTheme.displaySmall!
                            .copyWith(color: greyColor, fontSize: 10),
                      )
                    ],
                  )
                ],
              ),
            ),
            if ((sharedPreferences.get("role_id") == 2 &&
                    Provider.of<ProfileViewModel>(context, listen: false)
                            .getUserData
                            .id ==
                        exerciseValue.user_id) ||
                sharedPreferences.get("role_id") == 4 ||
                sharedPreferences.get("role_id") == 5)
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(
                      'Edit'.tr(),
                      style: TextStyle(color: orangeColor),
                    ),
                    value: 'Edit',
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Delete'.tr(),
                      style: TextStyle(color: Colors.red),
                    ),
                    value: 'Delete',
                  ),
                ],
                onSelected: (newVal) async {
                  if (newVal == 'Edit') {
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
                    print(exerciseValue.name);
                    print(exerciseValue.id);
                    //   Navigator.of(context)
                    //     .pushNamed('/EditExerciseView', arguments: {
                    //   'burn calories': BurnCaloriesController.text,
                    //   'name': nameController.text,
                    //   'description': descriptionController.text,
                    //   'id': '1', //TODO:
                    //   'image':
                    //       'https://media.istockphoto.com/photos/various-sport-equipments-on-grass-picture-id949190756?s=612x612'
                    // });
                    Provider.of<exercisesListViewModel>(context, listen: false)
                        .reset();
                    Provider.of<exercisesListViewModel>(context, listen: false)
                        .getExercisesData(lang: getLang(context));
                  } else if (newVal == 'Delete') {
                    print('yes');
                    final exerciseModel BackEndMessage =
                        await Provider.of<exercisesListViewModel>(context,
                                listen: false)
                            .deleteSpecificExerciseData(
                                context.locale == Locale('en') ? 'en' : 'ar',
                                exerciseValue.id);
                    if (BackEndMessage.message != '' ||
                        BackEndMessage.message != '') {
                      showSnackbar(
                          Text(BackEndMessage.message.toString()), context);
                    }
                    if (BackEndMessage.statusCode == 200) {
                      Provider.of<exercisesListViewModel>(context,
                              listen: false)
                          .reset();
                      Provider.of<exercisesListViewModel>(context,
                              listen: false)
                          .getExercisesData(lang: getLang(context));
                    }
                  }
                },
              ),
          ],
        ),
        InkWell(
          onTap: () {
            //TODO:
            // Navigator.pushNamed(context, '/anotherUserProfile',
            //     arguments: {'id': exerciseValue.user_id});
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
                    image: NetworkImage(
                        exerciseValue.exercise_img.toString().substring(0, 4) !=
                                'http'
                            ? '$ip/${exerciseValue.exercise_img}'
                            : exerciseValue.exercise_img.toString()),
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
                              Text(exerciseValue.name.toString(),
                                  style: TextStyle(
                                    color: blueColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                  ),
                                  overflow: TextOverflow.fade,
                                  maxLines: 2),
                              FittedBox(
                                child: Text(
                                  '${exerciseValue.burn_calories} Kcal',
                                  style: theme.textTheme.displaySmall,
                                ).tr(),
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     const Icon(
                              //       Icons.alarm,
                              //       color: Colors.white,
                              //       size: 25,
                              //     ),
                              //     Text(
                              //       '${exerciseValue.length} min',
                              //       style: theme.textTheme.displaySmall!
                              //           .copyWith(fontSize: 15),
                              //     )
                              //   ],
                              // ),
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
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: Container(
                    //     width: 100,
                    //     decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //           topRight: Radius.circular(15),
                    //           bottomRight: Radius.circular(15)),
                    //       color: orangeColor.withOpacity(0.5),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           FittedBox(
                    //             child: Text(
                    //               ' ',
                    //               style: theme.textTheme.displaySmall,
                    //             ),
                    //           ),
                    //           FittedBox(
                    //             child: Text(
                    //               '${exerciseValue.predicted_burnt_calories} Kcal',
                    //               style: theme.textTheme.displaySmall,
                    //             ),
                    //           ),
                    //           Icon(
                    //             Icons.electric_bolt_rounded,
                    //             color: exerciseValue.difficulty == 1
                    //                 ? Colors.green
                    //                 : (exerciseValue.difficulty == 2
                    //                     ? Colors.yellow
                    //                     : Colors.red),
                    //             size: 25,
                    //           ),
                    //           // FittedBox(
                    //           //   child: Text(
                    //           //     'Published by:\ncoach ${e.publisherName}',
                    //           //     style: theme.textTheme.displaySmall,
                    //           //   ),
                    //           // )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
