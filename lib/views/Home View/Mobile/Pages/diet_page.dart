import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Diet/diet_list_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';

class DietPage extends StatefulWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<DietListViewModel>(context, listen: false).reset();
      Provider.of<DietListViewModel>(context, listen: false)
          .getDietsList(lang: getLang(context));
    });

    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<DietListViewModel>(context, listen: false)
            .getDietsList(lang: getLang(context));
      }
    });
  }

  ScrollController _scrollController = ScrollController();
  TextEditingController _reviewController = TextEditingController();

  String mealString = 'Meals:'.tr();
  String kcalString = 'kcal'.tr();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return (Provider.of<DietListViewModel>(context, listen: true)
                .getIsLoading &&
            Provider.of<DietListViewModel>(context, listen: true)
                .getDiets
                .isEmpty)
        ? bigLoader(color: orangeColor)
        : (Provider.of<DietListViewModel>(context, listen: true)
                .getDiets
                .isEmpty
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('There are no diets',
                            style: theme.textTheme.bodySmall!
                                .copyWith(color: greyColor))
                        .tr(),
                    TextButton(
                        onPressed: () async {
                          Provider.of<DietListViewModel>(context, listen: false)
                              .reset();
                          await Provider.of<DietListViewModel>(context,
                                  listen: false)
                              .getDietsList(lang: getLang(context));
                        },
                        child: Text('Refresh', style: theme.textTheme.bodySmall)
                            .tr())
                  ],
                ),
              )
            : RefreshIndicator(
                color: orangeColor,
                onRefresh: () async {
                  Provider.of<DietListViewModel>(context, listen: false)
                      .reset();
                  await Provider.of<DietListViewModel>(context, listen: false)
                      .getDietsList(lang: getLang(context));
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        child: Consumer<DietListViewModel>(
                          builder: (context, diet, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: diet.getDiets
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
                                                Navigator.pushNamed(context,
                                                    '/anotherUserProfile',
                                                    arguments: {
                                                      'id': e.userId
                                                    });
                                              },
                                              child: ListTile(
                                                trailing: PopupMenuButton(
                                                  onSelected: (value) async {
                                                    switch (value) {
                                                      case 'edit':
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/editDiet',
                                                            arguments: {
                                                              'dietId': e.id,
                                                              'diet': e
                                                            });
                                                        break;

                                                      case 'save':
                                                        final response = await Provider
                                                                .of<DietListViewModel>(
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
                                                            e.saved = !e.saved;
                                                          });
                                                        }
                                                        break;

                                                      case 'delete':
                                                        await Provider.of<
                                                                    DietListViewModel>(
                                                                context,
                                                                listen: false)
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
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                        value: 'save',
                                                        child: Text(
                                                          e.saved
                                                              ? 'Saved'
                                                              : 'Save',
                                                          style: theme.textTheme
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
                                                title: Text(
                                                  '${e.userFname} ${e.userLname}',
                                                  style: theme
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                          color: orangeColor),
                                                ),
                                                leading: CircleAvatar(
                                                  backgroundImage:
                                                      NetworkImage(e.userImg),
                                                ),
                                                subtitle: Text(
                                                  e.createAt,
                                                  style: theme
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                          color: greyColor,
                                                          fontSize: 10),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 10),
                                              child: Text(
                                                e.name,
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  Text('Meals: ',
                                                          style: theme.textTheme
                                                              .bodySmall)
                                                      .tr(),
                                                  Text(
                                                    e.mealsCount.toString(),
                                                    style: theme
                                                        .textTheme.bodySmall!
                                                        .copyWith(
                                                            color: greyColor),
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 25,
                                                                vertical: 10),
                                                        child:
                                                            RatingBarIndicator(
                                                          rating: e.rating,
                                                          itemSize: 25,
                                                          itemCount: 5,
                                                          itemBuilder: (context,
                                                                  index) =>
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
                                                          'id': e.id,
                                                          'review': true,
                                                          'isReviewd':
                                                              e.reviewd,
                                                        });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Comments',
                                                        style: theme.textTheme
                                                            .bodySmall,
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
                                                child:
                                                    Consumer<DietListViewModel>(
                                                  builder: (context, review,
                                                          child) =>
                                                      review.getIsREviewLoading
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: bigLoader(
                                                                  color:
                                                                      orangeColor),
                                                            )
                                                          : TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            ctx) {
                                                                      _reviewController
                                                                          .clear();
                                                                      double
                                                                          stars =
                                                                          0;
                                                                      return AlertDialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
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
                                                              child: Text(
                                                                'Add a review',
                                                                style: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .amber),
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
                    if (Provider.of<DietListViewModel>(context, listen: true)
                            .getIsLoading &&
                        Provider.of<DietListViewModel>(context, listen: true)
                            .getDiets
                            .isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: bigLoader(color: orangeColor),
                      )
                  ],
                ),
              ));
  }
}
