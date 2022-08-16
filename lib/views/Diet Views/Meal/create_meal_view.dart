// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Food/foods_list_view_model.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Meal/create_meal_view_model.dart';
import 'package:provider/provider.dart';

class CreateMealView extends StatefulWidget {
  CreateMealView({Key? key}) : super(key: key);

  @override
  State<CreateMealView> createState() => _CreateMealViewState();
}

class _CreateMealViewState extends State<CreateMealView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _descController = TextEditingController();
  String kcalString = 'kcal'.tr();

  String selectedType = 'Breakfast';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CreateMealViewModel>(context, listen: false).reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: Consumer<CreateMealViewModel>(
        builder: (context, meal, child) => meal.getIsLoading
            ? bigLoader(color: orangeColor)
            : TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (meal.getPickedFoods.isEmpty) {
                      showSnackbar(
                          const Text('You have to add at least a one food')
                              .tr(),
                          context);
                    } else {
                      await meal.createMeal(
                          type: selectedType,
                          desc: _descController.text.trim(),
                          foodsIDs: meal.getPickedFoods,
                          lang: getLang(context),
                          context: context);
                    }
                  }
                },
                child: Text('Add', style: theme.textTheme.bodyMedium)),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Add meal',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Meal type ',
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<String>(
                    value: selectedType,
                    items: <String>[
                      'Breakfast',
                      'Lunch',
                      'Dinner',
                      'Snack',
                    ]
                        .map<DropdownMenuItem<String>>(
                            (String e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(
                                  e.tr(),
                                  style: theme.textTheme.bodySmall!
                                      .copyWith(color: blueColor),
                                )))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedType = value ?? selectedType;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) return 'Cannot be empty';
                        },
                        controller: _descController,
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        decoration: InputDecoration(
                          label:
                              FittedBox(child: const Text('Description').tr()),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          floatingLabelStyle: theme.textTheme.bodySmall,
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: orangeColor, width: 1.5),
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
                            borderSide:
                                BorderSide(color: orangeColor, width: 1.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () async {
                      final mealsId =
                          await Navigator.pushNamed(context, '/foodPicker')
                              as List;
                      mealsId.forEach((element) {
                        Provider.of<CreateMealViewModel>(context, listen: false)
                            .addToFoods(element);
                      });
                    },
                    child: Text(
                      '+ Add foods',
                      style: theme.textTheme.bodySmall,
                    ).tr()),
              ),
            ),
            Consumer2<CreateMealViewModel, FoodsListViewModel>(
              builder: (context, meal, foods, child) => meal
                      .getPickedFoods.isEmpty
                  ? const Text('')
                  : ListBody(
                      children: foods.getFoodsList
                          .where((element) =>
                              meal.getPickedFoods.contains(element.id))
                          .map(
                            (e) => Dismissible(
                              key: Key(e.id.toString()),
                              onDismissed: (direction) {
                                meal.removeFromFoods(e.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: blueColor, width: 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: ListTile(
                                  title: Text(
                                    e.name,
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        color: orangeColor, fontSize: 17),
                                  ),
                                  subtitle: Text(
                                    '${e.calories} $kcalString',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        color: greyColor, fontSize: 12),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      e.imageUrl,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
