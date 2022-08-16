import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/create_challenge_model.dart';
import 'package:home_workout_app/view_models/create_challenge_view_model.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class CreateChallengeView extends StatefulWidget {
  CreateChallengeView({Key? key}) : super(key: key);

  @override
  State<CreateChallengeView> createState() => _CreateChallengeViewState();
}

class _CreateChallengeViewState extends State<CreateChallengeView> {
  final formGlobalKey = GlobalKey<FormState>();
  final form1GlobalKey = GlobalKey<FormState>();
  final form2GlobalKey = GlobalKey<FormState>();
  TimeOfDay initialTime = TimeOfDay(hour: 0, minute: 0);
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController minuitesController = TextEditingController();
  TextEditingController repetitionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Future<List<CreateChallengeModel>>? futurechallengesList;
  // List<String> dropDownList = [];

  // String selectedDropDownValue = ''; //dropDownList[0];

  // List<CreateChallengeModel> posts = [];
  @override
  void initState() {
    super.initState();
    // futurechallengesList = GeneralChallengesViewModel().getData('en', 1);
    // print(futurechallengesList);
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<CreateChallengesViewModel>(context, listen: false)
          .resetData();
      futurechallengesList =
          Provider.of<CreateChallengesViewModel>(context, listen: false)
              .getData(context.locale == Locale('en') ? 'en' : 'ar', 0);

      // List data = jsonDecode(response.body)['data'] ?? [];

      // print(Provider.of<CreateChallengesViewModel>(context, listen: false).getChallengesList(lang));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    // final hours = initialTime.hour.toString().padLeft(2, '0');
    // final minuites = initialTime.minute.toString().padLeft(2, '0');

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Create challenge',
              style: theme.textTheme.bodyMedium!,
            ).tr(),
          ),
          body: Provider.of<CreateChallengesViewModel>(context).fetchedList ==
                  true
              ? SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: mq.size.height * 0.02,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       SizedBox(
                        //         height: mq.size.height * 0.02,
                        //       ),

                        //       SizedBox(
                        //         height: mq.size.height * 0.01,
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        SizedBox(
                          height: mq.size.height * 0.03,
                        ),

                        Container(
                          child: Form(
                            key: formGlobalKey,
                            child: Column(
                              children: [
                                Container(
                                  width: mq.size.width * 0.7,
                                  decoration: BoxDecoration(
                                      color: Colors.white70.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: TextFormField(
                                    controller: nameController,
                                    validator: (value) {
                                      return CreateChallengesViewModel()
                                          .checkName(
                                              value.toString(),
                                              context.locale == Locale('en')
                                                  ? 'en'
                                                  : 'ar');
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
                                      labelText: 'Name'.tr(),
                                      labelStyle: TextStyle(
                                          color: orangeColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      prefixIcon: Icon(
                                        CupertinoIcons
                                            .textformat_abc_dottedunderline,
                                        color: blueColor,
                                        size: 33,
                                      ),
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(20),
                                    ],
                                    style: TextStyle(
                                        color: blueColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    // maxLines: 5,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          Text("Select exercise's name: ").tr(),
                                    ),
                                  ],
                                ),
                                DropdownButton<String>(
                                  value: Provider.of<CreateChallengesViewModel>(
                                          context,
                                          listen: false)
                                      .dropDownNewValue,
                                  icon: Icon(Icons.arrow_downward,
                                      color: blueColor),
                                  elevation: 16,
                                  style: TextStyle(color: blueColor),
                                  underline: Container(
                                    height: 2,
                                    color: blueColor,
                                  ),
                                  onChanged: (String? newValue) {
                                    Provider.of<CreateChallengesViewModel>(
                                            context,
                                            listen: false)
                                        .setdropDownNewValue(newValue!);
                                  },
                                  items: Provider.of<CreateChallengesViewModel>(
                                          context)
                                      .dropDownList
                                      ?.map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: mq.size.height * 0.03,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: mq.size.width * 0.1),
                                  child: Consumer<CreateChallengesViewModel>(
                                    builder: (context, value, child) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        value.userImage != null &&
                                                value.userImage.path != ''
                                            ? Container(
                                                height: 150,
                                                width: 150,
                                                child: Image.file(
                                                  File(
                                                    Provider.of<CreateChallengesViewModel>(
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
                                            child: Text(value.userImage !=
                                                        null &&
                                                    value.userImage.path != ''
                                                ? 'Change photo'.tr()
                                                : 'Add photo'.tr()))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: mq.size.height * 0.01,
                                ),
                                Container(
                                  width: mq.size.width * 0.7,
                                  decoration: BoxDecoration(
                                      color: Colors.white70.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: TextFormField(
                                    controller: descriptionController,
                                    validator: (value) {
                                      return CreateChallengesViewModel()
                                          .checkDescription(
                                              value.toString(),
                                              context.locale == Locale('en')
                                                  ? 'en'
                                                  : 'ar');
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
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                                SizedBox(
                                  height: mq.size.height * 0.01,
                                ),

                                // SizedBox(
                                //   height: mq.size.height * 0.01,
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Challenge end date:',
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(color: orangeColor),
                                      ).tr(),
                                    ),
                                  ],
                                ),
                                Consumer<CreateChallengesViewModel>(
                                  builder: (context, value, child) => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        // DateFormat('yyyy-MM-dd')
                                        //             .format(value.challengeDate) ==
                                        //         DateFormat('yyyy-MM-dd')
                                        //             .format(DateTime.now())
                                        //     ? 'Year-Month-Day'
                                        // :
                                        DateFormat('yyyy-MM-dd')
                                            .format(value.challengeDate),
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(color: blueColor),
                                      ).tr(),
                                      IconButton(
                                        onPressed: () {
                                          value.changechallengeDate(context);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: orangeColor,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Practice by: ').tr(),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Provider.of<CreateChallengesViewModel>(
                                                  context,
                                                  listen: false)
                                              .changeIsTime();
                                        },
                                        child: Text(
                                            Provider.of<CreateChallengesViewModel>(
                                                        context,
                                                        listen: false)
                                                    .isTime
                                                ? 'Time'.tr()
                                                : 'Repetition'.tr()))
                                  ],
                                ),
                                SizedBox(
                                  height: mq.size.height * 0.01,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              if (Provider.of<CreateChallengesViewModel>(
                                      context,
                                      listen: false)
                                  .isTime)
                                Form(
                                  key: form1GlobalKey,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: mq.size.width * 0.35,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white70.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(3),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          controller: hoursController,
                                          validator: (value) {
                                            return CreateChallengesViewModel()
                                                .checkHours(
                                                    value.toString(),
                                                    context.locale ==
                                                            Locale('en')
                                                        ? 'en'
                                                        : 'ar');
                                          },
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: greyColor, width: 1.5),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 1.5),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: orangeColor,
                                                  width: 1.5),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            labelText: 'Hours'.tr(),
                                            labelStyle: TextStyle(
                                                color: orangeColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            prefixIcon: Icon(
                                              CupertinoIcons.time,
                                              color: blueColor,
                                              size: 33,
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                      SizedBox(
                                        width: mq.size.width * 0.03,
                                      ),
                                      Container(
                                        width: mq.size.width * 0.35,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white70.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(2),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            // LimitRange(0, 59),
                                          ],
                                          controller: minuitesController,
                                          validator: (value) {
                                            return CreateChallengesViewModel()
                                                .checkMinuites(
                                                    value.toString(),
                                                    context.locale ==
                                                            Locale('en')
                                                        ? 'en'
                                                        : 'ar');
                                          },
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: greyColor, width: 1.5),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 1.5),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: orangeColor,
                                                  width: 1.5),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            labelText: 'Minutes'.tr(),
                                            labelStyle: TextStyle(
                                                color: orangeColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            prefixIcon: Icon(
                                              CupertinoIcons.time,
                                              color: blueColor,
                                              size: 33,
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Form(
                                  key: form2GlobalKey,
                                  child: Container(
                                    width: mq.size.width * 0.35,
                                    decoration: BoxDecoration(
                                        color: Colors.white70.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(4),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      controller: repetitionController,
                                      validator: (value) {
                                        return CreateChallengesViewModel()
                                            .checkRepetition(
                                                value.toString(),
                                                context.locale == Locale('en')
                                                    ? 'en'
                                                    : 'ar');
                                      },
                                      decoration: InputDecoration(
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
                                        labelText: 'Repetition'.tr(),
                                        labelStyle: TextStyle(
                                            color: orangeColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        prefixIcon: Icon(
                                          CupertinoIcons.repeat,
                                          color: blueColor,
                                          size: 33,
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: blueColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                // print(object)
                                if (Provider.of<CreateChallengesViewModel>(
                                                context,
                                                listen: false)
                                            .userImage !=
                                        null &&
                                    Provider.of<CreateChallengesViewModel>(
                                                context,
                                                listen: false)
                                            .userImage
                                            .path !=
                                        '') {
                                  if (formGlobalKey.currentState!.validate() &&
                                      ((Provider.of<CreateChallengesViewModel>(
                                                      context,
                                                      listen: false)
                                                  .isTime &&
                                              form1GlobalKey.currentState!
                                                  .validate()) ||
                                          (!Provider.of<CreateChallengesViewModel>(
                                                      context,
                                                      listen: false)
                                                  .isTime &&
                                              form2GlobalKey.currentState!
                                                  .validate()))) {
                                    formGlobalKey.currentState!.save();
                                    final CreateChallengeModel BackEndMessage =
                                        await CreateChallengesViewModel().postChallengeInfo(
                                            nameController.text,
                                            Provider.of<CreateChallengesViewModel>(context, listen: false)
                                                .challengeDate
                                                .toString(),
                                            Provider.of<CreateChallengesViewModel>(context, listen: false).isTime
                                                ? Provider.of<CreateChallengesViewModel>(context, listen: false)
                                                    .getSumOfTime(
                                                        hoursController.text,
                                                        minuitesController.text)
                                                    .toString()
                                                : repetitionController.text,
                                            Provider.of<CreateChallengesViewModel>(
                                                    context,
                                                    listen: false)
                                                .getIdOfDropDownValue()
                                                .toString(),
                                            Provider.of<CreateChallengesViewModel>(
                                                    context,
                                                    listen: false)
                                                .isTime
                                                .toString(),
                                            Provider.of<CreateChallengesViewModel>(
                                                    context,
                                                    listen: false)
                                                .userImage,
                                            descriptionController.text,
                                            context.locale == Locale('en') ? 'en' : 'ar');
                                    print('ffffffffffssssssssssss');
                                    print(BackEndMessage.statusCode);
                                    print(BackEndMessage.message);
                                    if (BackEndMessage.message != null &&
                                        BackEndMessage.message != '') {
                                      showSnackbar(
                                          Text(BackEndMessage.message
                                              .toString()),
                                          context);
                                    }
                                    if (BackEndMessage.statusCode == 200 ||
                                        BackEndMessage.statusCode == 201) {
                                      nameController.clear();
                                      descriptionController.clear();
                                      repetitionController.clear();
                                      hoursController.clear();
                                      minuitesController.clear();
                                      Provider.of<CreateChallengesViewModel>(
                                              context,
                                              listen: false)
                                          .resetData();
                                      Navigator.of(context).pop();
                                    }
                                    // print(Provider.of<CreateChallengesViewModel>(
                                    //         context,
                                    //         listen: false)
                                    //     .dropDownList);
                                    // print(Provider.of<CreateChallengesViewModel>(
                                    //         context,
                                    //         listen: false)
                                    //     .getIdOfDropDownValue());
                                  }
                                } else {
                                  showSnackbar(Text('Add photo').tr(), context);
                                }
                              },
                              child: Text('Save').tr()),
                        ),
                      ],
                    ),
                  ),
                )
              : CustomLoading()),
    );
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
                Provider.of<CreateChallengesViewModel>(context, listen: false)
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
                Provider.of<CreateChallengesViewModel>(context, listen: false)
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

class LimitRange extends TextInputFormatter {
  LimitRange(
    this.minRange,
    this.maxRange,
  ) : assert(
          minRange < maxRange,
        );

  final int minRange;
  final int maxRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = int.parse(newValue.text.trim());
    if (value < minRange) {
      print('value print in between 0 - 59');
      return TextEditingValue(text: minRange.toString());
    } else if (value > maxRange) {
      print('not more 59');
      return TextEditingValue(text: maxRange.toString());
    }
    return newValue;
  }
}
/*

   // showDateRangePicker(context: context, firstDate: firstDate, lastDate: lastDate)
                        TimeOfDay? timepicked = await showTimePicker(
                            context: context,
                            initialTime: initialTime,
                            builder: (context, childWidget) {
                              return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                      // Using 24-Hour format
                                      alwaysUse24HourFormat: true),
                                  // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
                                  child: childWidget!);
                            });
                        if (timepicked != null) {
                          setState(() {
                            initialTime = timepicked;
                            print(timepicked.hour * 60 + timepicked.minute);
                          });
                        }
                        // showTimePicker(
                        //     context: context, initialTime: initialTime);

                        */
