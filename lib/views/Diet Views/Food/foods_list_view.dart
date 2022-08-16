import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Food/foods_list_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:home_workout_app/views/Home%20View/home_view_widgets.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';

class FoodsListView extends StatefulWidget {
  const FoodsListView({Key? key}) : super(key: key);

  @override
  State<FoodsListView> createState() => _FoodsListViewState();
}

class _FoodsListViewState extends State<FoodsListView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<FoodsListViewModel>(context, listen: false).reset();
      Provider.of<FoodsListViewModel>(context, listen: false)
          .getFoods(lang: getLang(context));
    });
  }

  String searchValue = '';
  TextEditingController _searchController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  String kcalString = 'kcal'.tr();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Foods list',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: Consumer<FoodsListViewModel>(
        builder: (context, food, child) => RefreshIndicator(
            color: orangeColor,
            onRefresh: () async {
              Provider.of<FoodsListViewModel>(context, listen: false).reset();
              Provider.of<FoodsListViewModel>(context, listen: false)
                  .getFoods(lang: getLang(context));
            },
            child: food.getIsLoading
                ? Center(
                    child: bigLoader(color: orangeColor),
                  )
                : (food.getFoodsList.isEmpty
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('There are no foods',
                                    style: theme.textTheme.bodySmall!
                                        .copyWith(color: greyColor))
                                .tr(),
                            TextButton(
                                onPressed: () async {
                                  Provider.of<FoodsListViewModel>(context,
                                          listen: false)
                                      .reset();
                                  Provider.of<FoodsListViewModel>(context,
                                          listen: false)
                                      .getFoods(lang: getLang(context));
                                },
                                child: Text('Refresh',
                                        style: theme.textTheme.bodySmall)
                                    .tr())
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                Provider.of<FoodsListViewModel>(context,
                                        listen: false)
                                    .setSearchValue(value);
                              },
                              maxLines: 1,
                              controller: _searchController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                label: FittedBox(child: Text('Search').tr()),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                floatingLabelStyle: theme.textTheme.bodySmall,
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: orangeColor, width: 1.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: greyColor, width: 1.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: orangeColor, width: 1.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
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
                                children: [
                                  Column(
                                    children: food.getFoodsList
                                        .where((element) => food
                                                .getSearchValue.isEmpty
                                            ? true
                                            : (element.name.contains(food
                                                    .getSearchValue
                                                    .trim()) ||
                                                element.description.contains(
                                                    food.getSearchValue
                                                        .trim())))
                                        .map(
                                          (e) => Container(
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: blueColor, width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: ListTile(
                                              title: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        e.name,
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color:
                                                                    orangeColor,
                                                                fontSize: 17),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${e.calories} $kcalString',
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color:
                                                                  orangeColor,
                                                              fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              subtitle: Text(
                                                e.description,
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: greyColor,
                                                        fontSize: 12),
                                              ),
                                              leading: CircleAvatar(
                                                radius: 50,
                                                onBackgroundImageError: (child,
                                                        st) =>
                                                    const LoadingContainer(),
                                                backgroundImage: NetworkImage(
                                                  //'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/full-body-workout-1563458040.jpg'
                                                  e.imageUrl,
                                                ),
                                              ),
                                              trailing:
                                                  Provider.of<ProfileViewModel>(
                                                                      context,
                                                                      listen:
                                                                          true)
                                                                  .getUserData
                                                                  .roleId ==
                                                              4 ||
                                                          Provider.of<ProfileViewModel>(
                                                                      context,
                                                                      listen:
                                                                          true)
                                                                  .getUserData
                                                                  .roleId ==
                                                              5
                                                      ? PopupMenuButton(
                                                          onSelected:
                                                              (value) async {
                                                            switch (value) {
                                                              case 'edit':
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    '/editFood',
                                                                    arguments: {
                                                                      'food': e
                                                                    });
                                                                break;

                                                              case 'delete':
                                                                await Provider.of<FoodsListViewModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .deleteFood(
                                                                        lang: getLang(
                                                                            context),
                                                                        foodId: e
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
                                                            PopupMenuItem(
                                                                value: 'delete',
                                                                child: Text(
                                                                  'Delete',
                                                                  style: theme
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.red),
                                                                ).tr())
                                                          ],
                                                        )
                                                      : null,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))),
      ),
    );
  }
}
