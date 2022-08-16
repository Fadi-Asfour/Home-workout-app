// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/view_models/Diet%20View%20Model/Food/create_food_view_model.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class CreateFoodView extends StatefulWidget {
  const CreateFoodView({Key? key}) : super(key: key);

  @override
  State<CreateFoodView> createState() => _CreateFoodViewState();
}

class _CreateFoodViewState extends State<CreateFoodView> {
  TextEditingController foodNameController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController descController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CreateFoodViewModel>(context, listen: false).reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create food',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) return 'Cannot be empty'.tr();
                      },
                      controller: foodNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: FittedBox(child: const Text('Food name').tr()),
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
                          borderSide:
                              BorderSide(color: orangeColor, width: 1.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) return 'Cannot be empty'.tr();
                      },
                      controller: descController,
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      decoration: InputDecoration(
                        label: FittedBox(child: const Text('Description').tr()),
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
                          borderSide:
                              BorderSide(color: orangeColor, width: 1.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150,
                      height: 70,
                      child: TextFormField(
                        validator: (value) {
                          if (int.tryParse(value!) == null)
                            return 'Invalid calories';
                        },
                        controller: caloriesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: FittedBox(child: const Text('Calories').tr()),
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
                ],
              ),
            ),
            if (Provider.of<CreateFoodViewModel>(context, listen: true)
                    .getPickedImage !=
                null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.file(
                    File(Provider.of<CreateFoodViewModel>(context, listen: true)
                        .getPickedImage!
                        .path),
                  ),
                ),
              ),
            Center(
              child: TextButton(
                onPressed: () async {
                  await Provider.of<CreateFoodViewModel>(context, listen: false)
                      .pickImage();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_rounded,
                      color: blueColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                            Provider.of<CreateFoodViewModel>(context,
                                            listen: true)
                                        .getPickedImage !=
                                    null
                                ? 'Change the food image'
                                : 'Add the food image',
                            style: theme.textTheme.bodySmall)
                        .tr(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Consumer<CreateFoodViewModel>(
                builder: (context, foodV, child) => Center(
                    child: foodV.getIsLoading
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: bigLoader(color: orangeColor),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await Provider.of<CreateFoodViewModel>(context,
                                        listen: false)
                                    .addFood(
                                        desc: descController.text.trim(),
                                        foodName:
                                            foodNameController.text.trim(),
                                        calories:
                                            caloriesController.text.trim(),
                                        lang: getLang(context),
                                        context: context);
                              }
                            },
                            child: const Text('Add').tr())),
              ),
            )
          ],
        ),
      ),
    );
  }
}
