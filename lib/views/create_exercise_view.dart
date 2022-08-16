import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/create_exercise_model.dart';
import 'package:home_workout_app/view_models/Workout_View_Model/create_exercise_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateExerciseView extends StatefulWidget {
  const CreateExerciseView({Key? key}) : super(key: key);

  @override
  State<CreateExerciseView> createState() => _CreateExerciseViewState();
}

class _CreateExerciseViewState extends State<CreateExerciseView> {
  // @override
  // void initState() {
  //   super.initState();
  //   // futureExerciseList = GeneralExerciseViewModel().getData('en', 1);
  //   // print(futureExerciseList);
  //   Future.delayed(Duration.zero).then((value) async {
  //     futureExerciseList =
  //         Provider.of<CreateExerciseViewModel>(context, listen: false)
  //             .getData(context.locale == Locale('en') ? 'en' : 'ar', 0);

  //     // List data = jsonDecode(response.body)['data'] ?? [];

  //     // print(Provider.of<CreateExerciseViewModel>(context, listen: false).getExerciseList(lang));
  //   });
  // }

  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController BurnCaloriesController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   Future.delayed(Duration.zero).then((value) {
  //     Provider.of<CreateExerciseViewModel>(context, listen: false).resetImage();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Create exercise',
            style: theme.textTheme.bodyMedium!,
          ).tr(),
        ),
        body: SafeArea(
          child: Container(
            // color: Colors.white,
            child: SingleChildScrollView(
              // controller: controller,
              child: Column(
                children: [
                  Center(
                    child: Form(
                      key: formGlobalKey,
                      child: Column(children: [
                        SizedBox(
                          height: mq.size.height * 0.1,
                        ),
                        Container(
                          width: mq.size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.white70.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              return CreateExerciseViewModel().checkName(
                                  value.toString(),
                                  context.locale == Locale('en') ? 'en' : 'ar');
                            },
                            decoration: InputDecoration(
                              // focusedErrorBorder:  OutlineInputBorder(
                              //   borderSide:
                              //       BorderSide(color: blueColor, width: 1.5),
                              //   borderRadius: BorderRadius.all(
                              //     Radius.circular(15),
                              //   ),
                              // ),
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
                              labelText: 'Name'.tr(),
                              labelStyle: TextStyle(
                                  color: orangeColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              prefixIcon: Icon(
                                CupertinoIcons.textformat_abc_dottedunderline,
                                color: blueColor,
                                size: 33,
                              ),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(40),
                            ],
                            style: TextStyle(
                                color: blueColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            // maxLines: 5,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        SizedBox(
                          height: mq.size.height * 0.1,
                        ),
                        Container(
                          width: mq.size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.white70.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            controller: descriptionController,
                            validator: (value) {
                              return CreateExerciseViewModel().checkDescription(
                                  value.toString(),
                                  context.locale == Locale('en') ? 'en' : 'ar');
                            },
                            decoration: InputDecoration(
                              // focusedErrorBorder:  OutlineInputBorder(
                              //   borderSide:
                              //       BorderSide(color: blueColor, width: 1.5),
                              //   borderRadius: BorderRadius.all(
                              //     Radius.circular(15),
                              //   ),
                              // ),

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
                              labelText: 'Description'.tr(),
                              labelStyle: TextStyle(
                                  color: orangeColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              prefixIcon: Icon(
                                Icons.description_outlined,
                                color: blueColor,
                                size: 33,
                              ),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(300),
                            ],
                            style: TextStyle(
                                color: blueColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          ),
                        ),
                        SizedBox(
                          height: mq.size.height * 0.1,
                        ),
                        Container(
                          width: mq.size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.white70.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: BurnCaloriesController,
                            validator: (value) {
                              return CreateExerciseViewModel().checkCalories(
                                  value.toString(),
                                  context.locale == Locale('en') ? 'en' : 'ar');
                            },
                            decoration: InputDecoration(
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
                              labelText: 'Burn calories'.tr(),
                              labelStyle: TextStyle(
                                  color: orangeColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              prefixIcon: Icon(
                                Icons.keyboard_capslock_outlined,
                                color: blueColor,
                                size: 33,
                              ),
                              suffixText: 'Kcal'.tr(),
                            ),
                            style: TextStyle(
                                color: blueColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        SizedBox(
                          height: mq.size.height * 0.1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mq.size.width * 0.1),
                          child: Consumer<CreateExerciseViewModel>(
                            builder: (context, value, child) => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                value.userImage != null &&
                                        value.userImage.path != ''
                                    ? Container(
                                        height: 150,
                                        width: 150,
                                        child: Image.file(
                                          File(
                                            Provider.of<CreateExerciseViewModel>(
                                                    context)
                                                .userImage
                                                .path,
                                          ),
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(),
                                ElevatedButton(
                                    onPressed: () async {
                                      buildDialog(context);
                                      print(value.userImage == null);
                                      print(value.userImage.path == '');
                                    },
                                    child: Text(value.userImage != null &&
                                                value.userImage.path != ''
                                            ? 'Change photo'
                                            : 'Add photo')
                                        .tr())
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: mq.size.height * 0.05,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              // final CreateExerciseModel BackEndMessage =
                              //     await CreateExerciseViewModel().postExerciseInfo(
                              //         'nameController.text',
                              //         '10',
                              //         Provider.of<CreateExerciseViewModel>(context,
                              //                 listen: false)
                              //             .userImage,
                              //         context.locale == Locale('en') ? 'en' : 'ar');
                              if (Provider.of<CreateExerciseViewModel>(context,
                                              listen: false)
                                          .userImage !=
                                      null &&
                                  Provider.of<CreateExerciseViewModel>(context,
                                              listen: false)
                                          .userImage
                                          .path !=
                                      '') {
                                if (formGlobalKey.currentState!.validate()) {
                                  formGlobalKey.currentState!.save();
                                  final CreateExerciseModel BackEndMessage =
                                      await CreateExerciseViewModel()
                                          .postExerciseInfo(
                                              nameController.text,
                                              descriptionController.text,
                                              BurnCaloriesController.text,
                                              Provider.of<CreateExerciseViewModel>(
                                                      context,
                                                      listen: false)
                                                  .userImage,
                                              '/excersise/create',
                                              context.locale == Locale('en')
                                                  ? 'en'
                                                  : 'ar');
                                  print('ffffffffffssssssssssss');
                                  print(BackEndMessage.statusCode);
                                  print(BackEndMessage.message);
                                  if (BackEndMessage.message != null &&
                                      BackEndMessage.message != '') {
                                    showSnackbar(
                                        Text(BackEndMessage.message.toString()),
                                        context);
                                  }
                                  if (BackEndMessage.statusCode == 201) {
                                    nameController.clear();
                                    BurnCaloriesController.clear();
                                    Provider.of<CreateExerciseViewModel>(
                                            context,
                                            listen: false)
                                        .resetImage();
                                    Navigator.of(context).pop();
                                  }
                                }
                              } else {
                                showSnackbar(Text('Add photo').tr(), context);
                              }

                              // final CreateExerciseModel BackEndMessage =
                              //     await CreateExerciseViewModel().editExerciseInfo(
                              //         'nameController.text',
                              //         '10',
                              //         // Provider.of<CreateExerciseViewModel>(context,
                              //         //         listen: false)
                              //         //     .userImage,
                              //         context.locale == Locale('en') ? 'en' : 'ar');
                            },
                            child: Text('Save').tr()),
                        SizedBox(
                          height: mq.size.height * 0.05,
                        ),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.of(context)
                        //           .pushNamed('/EditExerciseView', arguments: {
                        //         'burn calories': BurnCaloriesController.text,
                        //         'name': nameController.text,
                        //         'description': descriptionController.text,
                        //         'id': '1', //TODO:
                        //         'image':
                        //             'https://media.istockphoto.com/photos/various-sport-equipments-on-grass-picture-id949190756?s=612x612'
                        //       });
                        //     },
                        //     child: Text('edit')),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void buildDialog(BuildContext context) {
    final alert = AlertDialog(
      title: Text(
        'Photo type',
        style: TextStyle(color: blueColor),
      ).tr(),
      content: Container(
        height: 150,
        child: Column(
          children: [
            Divider(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<CreateExerciseViewModel>(context, listen: false)
                    .changePhoto(ImageSource.gallery);
              },
              child: Text(
                'From gallery',
                style: TextStyle(color: orangeColor),
              ).tr(),
            ),
            SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<CreateExerciseViewModel>(context, listen: false)
                    .changePhoto(ImageSource.camera);
              },
              child: Text(
                'From camera',
                style: TextStyle(color: orangeColor),
              ).tr(),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        // barrierDismissible: false,
        // barrierLabel: "ddddddddd",
        barrierColor: orangeColor.withOpacity(0.1),
        builder: (BuildContext ctx) {
          return alert;
        });
  }
}

/*
ElevatedButton(
                onPressed: () {
                  Provider.of<CreateExerciseViewModel>(context, listen: false)
                      .changePhoto(ImageSource.gallery);
                },
                child: Text('Add photo')),
            ElevatedButton(
                onPressed: () async {
                  // final CreateExerciseModel BackEndMessage =
                  //     await CreateExerciseViewModel().postExerciseInfo(
                  //         'nameController.text',
                  //         '10',
                  //         Provider.of<CreateExerciseViewModel>(context,
                  //                 listen: false)
                  //             .userImage,
                  //         context.locale == Locale('en') ? 'en' : 'ar');

                  final CreateExerciseModel BackEndMessage =
                      await CreateExerciseViewModel().editExerciseInfo(
                          'nameController.text',
                          '10',
                          // Provider.of<CreateExerciseViewModel>(context,
                          //         listen: false)
                          //     .userImage,
                          context.locale == Locale('en') ? 'en' : 'ar');
                },
                child: Text('Save')),
            ElevatedButton(
                onPressed: () async {
                  // final CreateExerciseModel BackEndMessage =
                  //     await CreateExerciseViewModel().postExerciseInfo(
                  //         'nameController.text',
                  //         '10',
                  //         Provider.of<CreateExerciseViewModel>(context,
                  //                 listen: false)
                  //             .userImage,
                  //         context.locale == Locale('en') ? 'en' : 'ar');

                  await CreateExerciseViewModel().deleteSpecificChallengeData(
                      context.locale == Locale('en') ? 'en' : 'ar', 10);
                },
                child: Text('delete')),
                */