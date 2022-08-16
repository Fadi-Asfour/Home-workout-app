import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/challenge_model.dart';
import 'package:home_workout_app/view_models/general_challenges_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:home_workout_app/views/Home%20View/home_view_widgets.dart';
import 'package:provider/provider.dart';

class GeneralChallengesView extends StatefulWidget {
  const GeneralChallengesView({Key? key}) : super(key: key);

  @override
  State<GeneralChallengesView> createState() => _GeneralChallengesViewState();
}

class _GeneralChallengesViewState extends State<GeneralChallengesView> {
  Future<List<ChallengeModel>>? futurechallengesList;
  // late List<ChallengeModel> challengesList;
  final ListViewController = ScrollController();
  @override
  void initState() {
    super.initState();
    // futurechallengesList = GeneralChallengesViewModel().getData('en', 1);
    // print(futurechallengesList);
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<GeneralChallengesViewModel>(context, listen: false).reset();
      Provider.of<GeneralChallengesViewModel>(context, listen: false).getData(
          context.locale == Locale('en') ? 'en' : 'ar',
          Provider.of<GeneralChallengesViewModel>(context, listen: false).page,
          'out');
      // futurechallengesList = GeneralChallengesViewModel()
      //     .getData(context.locale == Locale('en') ? 'en' : 'ar', 1);
      print(Provider.of<GeneralChallengesViewModel>(context, listen: false)
          .challengesList);
      // challengesList = await GeneralChallengesViewModel().getData('en', 1);
      ListViewController.addListener(() {
        if (ListViewController.position.maxScrollExtent ==
            ListViewController.offset) {
          Provider.of<GeneralChallengesViewModel>(context, listen: false)
              .setIsLoading(true);
          Provider.of<GeneralChallengesViewModel>(context, listen: false)
              .getData(
                  context.locale == Locale('en') ? 'en' : 'ar',
                  Provider.of<GeneralChallengesViewModel>(context,
                          listen: false)
                      .page,
                  'out');
          // print(object)
        }
      });
    });
    // futurechallengesList = List<ChallengeModel>();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   futurechallengesList = GeneralChallengesViewModel()
    //       .getData(context.locale == Locale('en') ? 'en' : 'ar', 1);
    //   print(futurechallengesList);
    // });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose

  //   ListViewController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    var role_id = sharedPreferences.getInt("role_id");
    return SafeArea(
      child: Scaffold(
        // bottomNavigationBar:
        // Provider.of<GeneralChallengesViewModel>(context, listen: true)
        //             .isLoading ==
        //         true
        //     ? bigLoader(color: orangeColor)
        //     : Container(),

        floatingActionButton: (role_id == 2 || role_id == 4 || role_id == 5)
            ? FloatingActionButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/createChallenge');
                  Provider.of<GeneralChallengesViewModel>(context,
                          listen: false)
                      .reset();
                  Provider.of<GeneralChallengesViewModel>(context,
                          listen: false)
                      .getData(
                          context.locale == Locale('en') ? 'en' : 'ar',
                          Provider.of<GeneralChallengesViewModel>(context,
                                  listen: false)
                              .page,
                          'out');
                },
                child: Icon(Icons.add),
              )
            : Container(),
        appBar: AppBar(
            title: Text(
          'Challenges'.tr(),
          style: theme.textTheme.bodyMedium!,
        ).tr()),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8),
            //   child: Text('Diagram'),
            // ),
            Expanded(
              child: Consumer<GeneralChallengesViewModel>(
                builder: ((context, value, _) => (Provider.of<
                            GeneralChallengesViewModel>(context, listen: true)
                        .getchallengesList!
                        .isEmpty
                    ? bigLoader(color: orangeColor)
                    : RefreshIndicator(
                        onRefresh: () async {
                          Provider.of<GeneralChallengesViewModel>(context,
                                  listen: false)
                              .reset();
                          Provider.of<GeneralChallengesViewModel>(context,
                                  listen: false)
                              .getData(
                                  context.locale == Locale('en') ? 'en' : 'ar',
                                  Provider.of<GeneralChallengesViewModel>(
                                          context,
                                          listen: false)
                                      .page,
                                  'out');
                        },
                        child: ListView.builder(
                          controller: ListViewController,
                          physics: AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          // scrollDirection: Axis.horizontal,
                          itemCount: value.challengesList?.length,
                          itemBuilder: ((context, index) {
                            if (index < value.challengesList!.length) {
                              final item = value.challengesList![index];
                              // return ListTile(title: Text(item));
                              return _buildList(
                                  context, index, value.challengesList![index]);
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                        ),
                      ))),
              ),
            ),
            Provider.of<GeneralChallengesViewModel>(context, listen: true)
                        .isLoading ==
                    true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: bigLoader(color: orangeColor),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _buildList(BuildContext context, int index, ChallengeModel challengeValue) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mq.size.width * 0.01, vertical: mq.size.height * 0.01),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/anotherUserProfile',
                            arguments: {'id': challengeValue.user_id});
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(challengeValue
                                              .user_img
                                              .toString()
                                              .substring(0, 4) !=
                                          'http'
                                      ? '$ip/${challengeValue.user_img}'
                                      : challengeValue.user_img.toString()
                                  // 'https://media.istockphoto.com/photos/various-sport-equipments-on-grass-picture-id949190756?s=612x612'
                                  ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${challengeValue.user_name}',
                                style: theme.textTheme.bodySmall!
                                    .copyWith(color: blueColor),
                              ),
                              Text(
                                '${challengeValue.created_at}',
                                style: theme.textTheme.displaySmall!
                                    .copyWith(color: greyColor, fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ), //&& challengeValue.user_id == sharedPreferences.get("user_id")
                    if ((sharedPreferences.get("role_id") == 2 &&
                            Provider.of<ProfileViewModel>(context,
                                        listen: false)
                                    .getUserData
                                    .id ==
                                challengeValue.user_id) ||
                        sharedPreferences.get("role_id") == 4 ||
                        sharedPreferences.get("role_id") == 5)
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
                              style: TextStyle(color: Colors.red),
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
                            final ChallengeModel BackEndMessage =
                                await Provider.of<GeneralChallengesViewModel>(
                                        context,
                                        listen: false)
                                    .deleteSpecificChallengeData(
                                        context.locale == Locale('en')
                                            ? 'en'
                                            : 'ar',
                                        // 2
                                        challengeValue.id);

                            if (BackEndMessage.message != '' ||
                                BackEndMessage.message != '') {
                              showSnackbar(
                                  Text(BackEndMessage.message.toString()),
                                  context);
                            }
                            if (BackEndMessage.statusCode == 200) {
                              Provider.of<GeneralChallengesViewModel>(context,
                                      listen: false)
                                  .reset();
                              Provider.of<GeneralChallengesViewModel>(context,
                                      listen: false)
                                  .getData(
                                      context.locale == Locale('en')
                                          ? 'en'
                                          : 'ar',
                                      Provider.of<GeneralChallengesViewModel>(
                                              context,
                                              listen: false)
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
                      if (challengeValue.ex_id?.toInt() == 3) {
                        buildDialog(context, challengeValue);
                      } else {
                        await Navigator.pushNamed(context, '/specificChallenge',
                            arguments: {
                              'id': challengeValue.id,
                              'sensor': false,
                              'count': challengeValue.total_count
                            });
                      }
                      Provider.of<GeneralChallengesViewModel>(context,
                              listen: false)
                          .reset();
                      Provider.of<GeneralChallengesViewModel>(context,
                              listen: false)
                          .getData(
                              context.locale == Locale('en') ? 'en' : 'ar',
                              Provider.of<GeneralChallengesViewModel>(context,
                                      listen: false)
                                  .page,
                              'out');
                    } else {
                      showSnackbar(
                          Text('Please! Subscribe before').tr(), context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: mq.size.width * 0.3,
                        height: mq.size.height * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            loadingBuilder: (context, child, loadingProgress) =>
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(challengeValue.name.toString()),
                            SizedBox(
                              height: mq.size.height * 0.01,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Container(
                                child: Text(
                                  challengeValue.desc.toString(),
                                  style: TextStyle(color: blueColor),
                                  overflow: TextOverflow.fade,
                                  maxLines: 5,
                                  // softWrap: false,
                                  // textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: mq.size.height * 0.01,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        challengeValue.sub_count.toString() +
                            ' participants'.tr(),
                        style: TextStyle(
                            color: blueColor, fontWeight: FontWeight.w300)),
                    ElevatedButton(
                        onPressed: () async {
                          final ChallengeModel BackEndMessage = await Provider
                                  .of<GeneralChallengesViewModel>(context,
                                      listen: false)
                              .sendParticipate(
                                  context.locale == Locale('en') ? 'en' : 'ar',
                                  // 2
                                  challengeValue.id);

                          if (BackEndMessage.message != '' ||
                              BackEndMessage.message != '') {
                            showSnackbar(
                                Text(BackEndMessage.message.toString()),
                                context);
                          }
                          if (BackEndMessage.statusCode == 200) {
                            Provider.of<GeneralChallengesViewModel>(context,
                                    listen: false)
                                .reset();
                            Provider.of<GeneralChallengesViewModel>(context,
                                    listen: false)
                                .getData(
                                    context.locale == Locale('en')
                                        ? 'en'
                                        : 'ar',
                                    Provider.of<GeneralChallengesViewModel>(
                                            context,
                                            listen: false)
                                        .page,
                                    'out');
                          }
                        },
                        child: Text(
                          challengeValue.is_sub! ? 'Unsubscribe' : 'Subscribe',
                        ).tr())
                  ],
                )
              ],
            ),
          ),
        ));
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
