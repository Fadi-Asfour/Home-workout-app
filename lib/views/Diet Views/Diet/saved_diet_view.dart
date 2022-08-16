import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Diet/saved_diets_view_model.dart';
import 'package:provider/provider.dart';

import '../../../components.dart';
import '../../../constants.dart';
import '../../../view_models/Diet View Model/Diet/diet_list_view_model.dart';
import '../../../view_models/profile_view_model.dart';
import '../../Posts View/post_view_widgets.dart';

class SavedDietsView extends StatefulWidget {
  const SavedDietsView({Key? key}) : super(key: key);

  @override
  State<SavedDietsView> createState() => _SavedDietsViewState();
}

class _SavedDietsViewState extends State<SavedDietsView> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _reviewController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<SavedDietsViewModel>(context, listen: false).reset();
      Provider.of<SavedDietsViewModel>(context, listen: false).getDietsList(
        lang: context.locale == const Locale('en') ? 'en' : 'ar',
      );
      _scrollController.addListener(() {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          Provider.of<SavedDietsViewModel>(context, listen: false).getDietsList(
            lang: context.locale == const Locale('en') ? 'en' : 'ar',
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Saved diets',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: Consumer<SavedDietsViewModel>(
        builder: (context, saveddiets, child) => (saveddiets.getIsLoading &&
                saveddiets.getSavedDiets.isEmpty)
            ? Center(child: bigLoader(color: orangeColor))
            : (saveddiets.getSavedDiets.isEmpty
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'There are no saved diets',
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: greyColor),
                        ).tr(),
                        TextButton(
                          onPressed: () async {
                            Provider.of<SavedDietsViewModel>(context,
                                    listen: false)
                                .setPage(0);
                            Provider.of<SavedDietsViewModel>(context,
                                    listen: false)
                                .reset();
                            await Provider.of<SavedDietsViewModel>(context,
                                    listen: false)
                                .getDietsList(
                              lang: context.locale == const Locale('en')
                                  ? 'en'
                                  : 'ar',
                            );
                          },
                          child: Text(
                            'Refresh',
                            style: theme.textTheme.bodySmall!.copyWith(
                                color: orangeColor,
                                fontWeight: FontWeight.w300),
                          ).tr(),
                        )
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: orangeColor,
                    onRefresh: () async {
                      Provider.of<SavedDietsViewModel>(context, listen: false)
                          .setPage(0);
                      Provider.of<SavedDietsViewModel>(context, listen: false)
                          .reset();
                      await Provider.of<SavedDietsViewModel>(context,
                              listen: false)
                          .getDietsList(
                        lang:
                            context.locale == const Locale('en') ? 'en' : 'ar',
                      );
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            child: Column(
                              children: saveddiets.getSavedDiets
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
                                                  color: blueColor, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                trailing: PopupMenuButton(
                                                  onSelected: (value) async {
                                                    switch (value) {
                                                      case 'save':
                                                        await Provider.of<
                                                                    SavedDietsViewModel>(
                                                                context,
                                                                listen: false)
                                                            .unsaveDiet(
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
                                                          'Saved',
                                                          style: theme.textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .amber),
                                                        ).tr()),
                                                  ],
                                                ),
                                                title: InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        '/anotherUserProfile',
                                                        arguments: {
                                                          'id': e.userId
                                                        });
                                                  },
                                                  child: Text(
                                                    '${e.userFname} ${e.userLname}',
                                                    style: theme
                                                        .textTheme.bodySmall!
                                                        .copyWith(
                                                            color: orangeColor),
                                                  ),
                                                ),
                                                leading: InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        '/anotherUserProfile',
                                                        arguments: {
                                                          'id': e.userId
                                                        });
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(e.userImg),
                                                  ),
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25,
                                                        vertical: 10),
                                                child: Text(
                                                  e.name,
                                                  style: theme
                                                      .textTheme.bodyMedium,
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
                                                            style: theme
                                                                .textTheme
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
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      25,
                                                                  vertical: 10),
                                                          child:
                                                              RatingBarIndicator(
                                                            rating: e.rating,
                                                            itemSize: 25,
                                                            itemCount: 5,
                                                            itemBuilder:
                                                                (context,
                                                                        index) =>
                                                                    const Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                          )),
                                                      Text(
                                                        e.rating.toString(),
                                                        style: theme.textTheme
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
                        if (saveddiets.getIsLoading &&
                            saveddiets.getSavedDiets.isNotEmpty)
                          bigLoader(color: orangeColor)
                      ],
                    ),
                  )),
      ),
    );
  }
}
