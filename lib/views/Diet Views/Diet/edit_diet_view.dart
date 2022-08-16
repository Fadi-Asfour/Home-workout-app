// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/diet_model.dart';
import 'package:home_workout_app/models/meal_model.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Diet/edit_diet_view_model.dart';
import 'package:provider/provider.dart';

import '../../../components.dart';
import '../../../view_models/Diet View Model/Diet/specific_diet_view_model.dart';
import '../../../view_models/Diet View Model/Meal/meal_list_view_model.dart';

class EditDietView extends StatefulWidget {
  EditDietView({Key? key}) : super(key: key);

  @override
  State<EditDietView> createState() => _EditDietViewState();
}

class _EditDietViewState extends State<EditDietView> {
  TextEditingController _nameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<MealsListViewModel>(context, listen: false)
          .getMeals(lang: getLang(context));
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      diet = args['diet'] ?? DietModel();

      Provider.of<SpecificDietViewModel>(context, listen: false)
          .setSpecDiet(lang: getLang(context), id: diet.id, context: context);

      _nameController.text = diet.name;
    });
  }

  DietModel diet = DietModel();

  String kcalString = 'kcal'.tr();
  String dayString = 'Day'.tr();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: Consumer<EditDietViewModel>(
        builder: (context, editDiet, child) => editDiet.getIsLoading
            ? bigLoader(color: orangeColor)
            : TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await editDiet.editDiet(
                        name: _nameController.text.trim(),
                        lang: getLang(context),
                        id: diet.id,
                        context: context);
                  }
                },
                child: Text('Edit', style: theme.textTheme.bodyMedium)),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Edit diet',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Form(
            child: Form(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Meals',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, '/mealPicker');
          //     },
          //     child: Text(
          //       '+ Add meals',
          //       style: theme.textTheme.bodySmall!.copyWith(
          //         color: blueColor,
          //       ),
          //     ),
          //   ),
          // ),
          // Consumer2<SpecificDietViewModel, EditDietViewModel>(
          //   builder: (context, diet2, editDiet, child) => diet2.getIsLoading
          //       ? bigLoader(color: orangeColor)
          //       : ListBody(
          //           children: diet2.getDiet.meals
          //               .map((e) => Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Padding(
          //                         padding: const EdgeInsets.symmetric(
          //                             horizontal: 25, vertical: 10),
          //                         child: Text(
          //                           '$dayString ${e['day']}:',
          //                           style: theme.textTheme.bodySmall!
          //                               .copyWith(color: blueColor),
          //                         ),
          //                       ),
          //                       Column(
          //                           children: e['meals'].map<Widget>((meal) {
          //                         final mealData = meal as MealModel;
          //                         return Dismissible(
          //                           key: Key(mealData.id.toString()),
          //                           onDismissed: (dir) {
          //                             editDiet.addToDeletedMealsId(mealData.id);
          //                           },
          //                           child: Container(
          //                             padding: const EdgeInsets.all(8),
          //                             margin: const EdgeInsets.all(8),
          //                             decoration: BoxDecoration(
          //                                 border: Border.all(
          //                                     color: blueColor, width: 1),
          //                                 borderRadius:
          //                                     BorderRadius.circular(15)),
          //                             child: ListTile(
          //                               title: Column(
          //                                 crossAxisAlignment:
          //                                     CrossAxisAlignment.start,
          //                                 children: [
          //                                   Row(
          //                                     mainAxisAlignment:
          //                                         MainAxisAlignment
          //                                             .spaceBetween,
          //                                     children: [
          //                                       Text(
          //                                         mealData.type,
          //                                         style: theme
          //                                             .textTheme.bodySmall!
          //                                             .copyWith(
          //                                                 color: orangeColor,
          //                                                 fontSize: 17),
          //                                       ),
          //                                       Text(
          //                                         '${mealData.calories} $kcalString',
          //                                         style: theme
          //                                             .textTheme.bodySmall!
          //                                             .copyWith(
          //                                                 color: orangeColor,
          //                                                 fontSize: 12),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                   Text(
          //                                     mealData.description,
          //                                     style: theme.textTheme.bodySmall!
          //                                         .copyWith(
          //                                             color: greyColor,
          //                                             fontSize: 12),
          //                                   ),
          //                                 ],
          //                               ),
          //                               subtitle: ExpansionTile(
          //                                 title: Text(
          //                                   'Foods',
          //                                   style: theme.textTheme.bodySmall!
          //                                       .copyWith(color: blueColor),
          //                                 ),
          //                                 children: mealData.foods
          //                                     .map(
          //                                       (e) => Container(
          //                                         padding:
          //                                             const EdgeInsets.all(8),
          //                                         margin:
          //                                             const EdgeInsets.all(8),
          //                                         decoration: BoxDecoration(
          //                                             border: Border.all(
          //                                                 color: blueColor,
          //                                                 width: 1),
          //                                             borderRadius:
          //                                                 BorderRadius.circular(
          //                                                     15)),
          //                                         child: ListTile(
          //                                           title: Text(
          //                                             e.name,
          //                                             style: theme
          //                                                 .textTheme.bodySmall!
          //                                                 .copyWith(
          //                                                     color:
          //                                                         orangeColor,
          //                                                     fontSize: 17),
          //                                           ),
          //                                           subtitle: Text(
          //                                             '${e.calories} $kcalString',
          //                                             style: theme
          //                                                 .textTheme.bodySmall!
          //                                                 .copyWith(
          //                                                     color: greyColor,
          //                                                     fontSize: 12),
          //                                           ),
          //                                           leading: CircleAvatar(
          //                                             radius: 50,
          //                                             backgroundImage:
          //                                                 NetworkImage(
          //                                                     e.imageUrl),
          //                                           ),
          //                                         ),
          //                                       ),
          //                                     )
          //                                     .toList(),
          //                               ),
          //                               // trailing:
          //                               //     Provider.of<ProfileViewModel>(
          //                               //                         context,
          //                               //                         listen:
          //                               //                             true)
          //                               //                     .getUserData
          //                               //                     .roleId ==
          //                               //                 4 ||
          //                               //             Provider.of<ProfileViewModel>(
          //                               //                         context,
          //                               //                         listen:
          //                               //                             true)
          //                               //                     .getUserData
          //                               //                     .roleId ==
          //                               //                 5
          //                               //         ? PopupMenuButton(
          //                               //             onSelected:
          //                               //                 (value) async {
          //                               //               switch (value) {
          //                               //                 case 'edit':
          //                               //                   Navigator.pushNamed(
          //                               //                       context,
          //                               //                       '/editMeal',
          //                               //                       arguments: {
          //                               //                         'meal': e
          //                               //                       });
          //                               //                   break;

          //                               //                 case 'delete':
          //                               //                   await Provider.of<MealsListViewModel>(
          //                               //                           context,
          //                               //                           listen:
          //                               //                               false)
          //                               //                       .deleteMeal(
          //                               //                           lang: getLang(
          //                               //                               context),
          //                               //                           mealId: mealData
          //                               //                               .id,
          //                               //                           context:
          //                               //                               context);
          //                               //                   break;
          //                               //                 default:
          //                               //               }
          //                               //             },
          //                               //             itemBuilder:
          //                               //                 (context) => [
          //                               //               PopupMenuItem(
          //                               //                   value: 'edit',
          //                               //                   child: Text(
          //                               //                     'Edit',
          //                               //                     style: theme
          //                               //                         .textTheme
          //                               //                         .bodySmall!
          //                               //                         .copyWith(
          //                               //                             color:
          //                               //                                 blueColor),
          //                               //                   ).tr()),
          //                               //               PopupMenuItem(
          //                               //                   value: 'delete',
          //                               //                   child: Text(
          //                               //                     'Delete',
          //                               //                     style: theme
          //                               //                         .textTheme
          //                               //                         .bodySmall!
          //                               //                         .copyWith(
          //                               //                             color:
          //                               //                                 Colors.red),
          //                               //                   ).tr())
          //                               //             ],
          //                               //           )
          //                               //         : null,
          //                             ),
          //                           ),
          //                         );
          //                       }).toList()),
          //                       // Divider(
          //                       //   indent: 50,
          //                       //   endIndent: 50,
          //                       //   thickness: 1,
          //                       //   color: orangeColor,
          //                       // )
          //                     ],
          //                   ))
          //               .toList(),
          //         ),
          // )

          TextButton(
              onPressed: () {
                Provider.of<EditDietViewModel>(context, listen: false)
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
          Consumer<EditDietViewModel>(
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
                      children:
                          Provider.of<MealsListViewModel>(context, listen: true)
                              .getMealsList
                              .where((element) => createDiet
                                  .getMeals[createDiet.getMeals.indexOf(e1)]
                                  .contains(element.id))
                              .map((e) {
                        index++;
                        log((e.id + createDiet.getMeals.indexOf(e1) + 1)
                            .toString());
                        if (Provider.of<MealsListViewModel>(context,
                                listen: true)
                            .getIsLoading)
                          return bigLoader(color: orangeColor);
                        else
                          return Dismissible(
                            key: Key((e.id + index).toString()),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              style: theme.textTheme.bodySmall!
                                                  .copyWith(
                                                      color: orangeColor,
                                                      fontSize: 17),
                                            ),
                                            subtitle: Text(
                                              '${e.calories} $kcalString',
                                              style: theme.textTheme.bodySmall!
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
                          );
                      }).toList(),
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
