// ignore_for_file: avoid_single_cascade_in_expression_statements, curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Food/foods_list_view_model.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Meal/create_meal_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';

class FoodsPickerListView extends StatefulWidget {
  const FoodsPickerListView({Key? key}) : super(key: key);

  @override
  State<FoodsPickerListView> createState() => _FoodsPickerListViewState();
}

class _FoodsPickerListViewState extends State<FoodsPickerListView> {
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

  TextEditingController _searchController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  String kcalString = 'kcal'.tr();

  List<int> mealsId = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, mealsId);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 30,
          child: Center(
            child: Text(
              'Press back button when finished',
              style: theme.textTheme.bodySmall!.copyWith(color: greyColor),
            ).tr(),
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, mealsId);
            },
            icon: Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Foods list',
            style: theme.textTheme.bodyMedium!,
          ).tr(),
        ),
        body: Consumer2<FoodsListViewModel, CreateMealViewModel>(
          builder: (context, food, meal, child) => RefreshIndicator(
              color: orangeColor,
              onRefresh: () async {
                food.reset();
                food..getFoods(lang: getLang(context));
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
                                    borderSide: BorderSide(
                                        color: greyColor, width: 1.5),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.5),
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
                                            (e) => InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (!mealsId.contains(e.id)) {
                                                    mealsId.add(e.id);
                                                  } else {
                                                    mealsId.removeWhere(
                                                        (element) =>
                                                            element == e.id);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                margin: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: mealsId
                                                            .contains(e.id)
                                                        ? blueColor
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                        color: blueColor,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: ListTile(
                                                  trailing: Text(
                                                    '${e.calories} $kcalString',
                                                    style: theme
                                                        .textTheme.bodySmall!
                                                        .copyWith(
                                                            color: orangeColor,
                                                            fontSize: 12),
                                                  ),
                                                  title: Text(
                                                    e.name,
                                                    style: theme
                                                        .textTheme.bodySmall!
                                                        .copyWith(
                                                            color: orangeColor,
                                                            fontSize: 17),
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
                                                    backgroundImage:
                                                        NetworkImage(
                                                      e.imageUrl,
                                                    ),
                                                  ),
                                                ),
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
      ),
    );
  }
}
