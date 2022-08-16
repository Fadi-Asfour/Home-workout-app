import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';

import '../../../components.dart';
import '../../../view_models/Diet View Model/Diet/create_diet_view_model.dart';
import '../../../view_models/Diet View Model/Meal/meal_list_view_model.dart';
import '../../../view_models/profile_view_model.dart';

class CreateDietView extends StatefulWidget {
  const CreateDietView({Key? key}) : super(key: key);

  @override
  State<CreateDietView> createState() => _CreateDietViewState();
}

class _CreateDietViewState extends State<CreateDietView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<CreateDietViewModel>(context, listen: false).reset();
    });
  }

  TextEditingController _nameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String kcalString = 'kcal'.tr();
  String dayString = 'Day'.tr();
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.size.width * 0.40,
        ),
        child: Consumer<CreateDietViewModel>(
          builder: (context, diet, child) => diet.getIsLoading
              ? bigLoader(color: orangeColor)
              : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await diet.createMeal(
                          name: _nameController.text.trim(),
                          context: context,
                          lang: getLang(context));
                    }
                  },
                  child: FittedBox(child: const Text('Add').tr())),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create diet',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) return 'Cannot be empty'.tr();
                },
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  label: FittedBox(child: const Text('Diet name').tr()),
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
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Provider.of<CreateDietViewModel>(context, listen: false)
                    .addDayToMeals(context);
              },
              child: Text(
                '+ Add day',
                style: theme.textTheme.bodySmall!.copyWith(color: blueColor),
              ).tr()),
          const Divider(
            indent: 50,
            endIndent: 50,
            thickness: 1,
          ),
          Consumer<CreateDietViewModel>(
            builder: (context, createDiet, child) => ListBody(
              children: createDiet.getMeals.map((e1) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                            '$dayString ${createDiet.getMeals.indexOf(e1) + 1}:'),
                        IconButton(
                            onPressed: () {
                              createDiet
                                  .deleteDay(createDiet.getMeals.indexOf(e1));
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ))
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        final mealsID =
                            await Navigator.pushNamed(context, '/mealPicker')
                                as List<int>;

                        mealsID.forEach((element) {
                          createDiet.addToMeals(
                              element, createDiet.getMeals.indexOf(e1));
                        });
                      },
                      child: Text(
                        '+ Add meals',
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: blueColor),
                      ).tr(),
                    ),
                    Column(
                      children: Provider.of<MealsListViewModel>(context,
                              listen: false)
                          .getMealsList
                          .where((element) => createDiet
                              .getMeals[createDiet.getMeals.indexOf(e1)]
                              .contains(element.id))
                          .map(
                            (e) => Dismissible(
                              key: Key(e.id.toString()),
                              onDismissed: (dir) {
                                createDiet.removeFromMeals(
                                    e.id, createDiet.getMeals.indexOf(e1));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: blueColor, width: 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            e.type,
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(
                                                    color: orangeColor,
                                                    fontSize: 17),
                                          ),
                                          Text(
                                            '${e.calories} $kcalString',
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(
                                                    color: orangeColor,
                                                    fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        e.description,
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: greyColor, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  subtitle: ExpansionTile(
                                    title: Text(
                                      'Foods',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(color: blueColor),
                                    ),
                                    children: e.foods
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
                                              title: Text(
                                                e.name,
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: orangeColor,
                                                        fontSize: 17),
                                              ),
                                              subtitle: Text(
                                                '${e.calories} $kcalString',
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: greyColor,
                                                        fontSize: 12),
                                              ),
                                              leading: CircleAvatar(
                                                radius: 50,
                                                backgroundImage:
                                                    NetworkImage(e.imageUrl),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    Divider(
                      indent: 50,
                      endIndent: 50,
                      thickness: 1,
                      color: blueColor,
                    )
                  ],
                );
              }).toList(),
            ),
          )
        ],
      )),
    );
  }
}
