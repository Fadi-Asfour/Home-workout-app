import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/user_information_view_model.dart';
import 'package:provider/provider.dart';
import 'user_information_widgets.dart';

class Details1Page extends StatelessWidget {
  Details1Page(
      {required this.nextFunction,
      required this.heightController,
      required this.weightController,
      required this.formkey,
      Key? key})
      : super(key: key);
  Function nextFunction;
  TextEditingController weightController;
  TextEditingController heightController;
  GlobalKey<FormState> formkey;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => nextFunction(),
        child: Provider.of<UserInformationViewModel>(context, listen: true)
                .getIsLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserInfoCustomText(
              text: 'Your gender:',
              color: orangeColor,
            ),
            Consumer<UserInformationViewModel>(
              builder: (context, value, child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      value.changeGender(Gender.female);
                    },
                    child: GenderContainer(
                        color: value.gender == Gender.female
                            ? orangeColor
                            : greyColor,
                        imagePath: 'assets/images/female.png'),
                  ),
                  InkWell(
                    onTap: () {
                      value.changeGender(Gender.male);
                    },
                    child: GenderContainer(
                        color: value.gender == Gender.male
                            ? orangeColor
                            : greyColor,
                        imagePath: 'assets/images/male.png'),
                  ),
                ],
              ),
            ),
            UserInfoCustomText(text: 'Your birthdate:', color: orangeColor),
            Consumer<UserInformationViewModel>(
              builder: (context, value, child) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('yyyy-MM-dd').format(value.birthdate) ==
                            DateFormat('yyyy-MM-dd').format(DateTime.now())
                        ? 'Year-Month-Day'
                        : DateFormat('yyyy-MM-dd').format(value.birthdate),
                    style:
                        theme.textTheme.bodySmall!.copyWith(color: blueColor),
                  ).tr(),
                  IconButton(
                    onPressed: () {
                      value.changeBirthdate(context);
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
            UserInfoCustomText(
              text: 'Your Height & Weight:',
              color: orangeColor,
            ),
            Form(
              key: formkey,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mq.size.width * 0.28),
                      child: TextFormField(
                        controller: heightController,
                        validator: (value) {
                          if (double.tryParse(value.toString()) == null) {
                            return 'Invalid height'.tr();
                          }
                        },
                        onSaved: (val) {},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixIcon: Consumer<UserInformationViewModel>(
                            builder: (context, value, child) => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (value.weightUnit != Units.cm) {
                                      value.ChangeHeightUnit(Units.cm);
                                    }
                                  },
                                  child: Text(
                                    'cm'.tr(),
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        fontSize: value.heightUnit == Units.cm
                                            ? 17
                                            : 15,
                                        color: value.heightUnit == Units.cm
                                            ? orangeColor
                                            : greyColor),
                                  ).tr(),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (value.weightUnit != Units.ft) {
                                      value.ChangeHeightUnit(Units.ft);
                                    }
                                  },
                                  child: Text(
                                    'ft',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        fontSize: value.heightUnit == Units.ft
                                            ? 17
                                            : 15,
                                        color: value.heightUnit == Units.ft
                                            ? orangeColor
                                            : greyColor),
                                  ).tr(),
                                )
                              ],
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.height,
                            color: orangeColor,
                          ),
                          label: FittedBox(child: const Text('Height').tr()),
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
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mq.size.width * 0.28, vertical: 10),
                    child: TextFormField(
                      controller: weightController,
                      validator: (value) {
                        if (double.tryParse(value.toString()) == null) {
                          return 'Invalid weight'.tr();
                        }
                      },
                      onSaved: (val) {},
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixIcon: Consumer<UserInformationViewModel>(
                          builder: (context, value, child) => Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (value.weightUnit != Units.kg) {
                                    value.ChangeWeightUnit(Units.kg);
                                  }
                                },
                                child: Text(
                                  'Kg',
                                  style: theme.textTheme.bodySmall!.copyWith(
                                      fontSize: value.weightUnit == Units.kg
                                          ? 15
                                          : 12,
                                      color: value.weightUnit == Units.kg
                                          ? orangeColor
                                          : greyColor),
                                ).tr(),
                              ),
                              InkWell(
                                onTap: () {
                                  if (value.weightUnit != Units.lb) {
                                    value.ChangeWeightUnit(Units.lb);
                                  }
                                },
                                child: Text(
                                  'lb',
                                  style: theme.textTheme.bodySmall!.copyWith(
                                      fontSize: value.weightUnit == Units.lb
                                          ? 17
                                          : 15,
                                      color: value.weightUnit == Units.lb
                                          ? orangeColor
                                          : greyColor),
                                ).tr(),
                              )
                            ],
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.monitor_weight_outlined,
                          color: orangeColor,
                        ),
                        label: FittedBox(child: const Text('Weight').tr()),
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
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserInfoCustomText(text: 'Country: ', color: orangeColor),
                // Text(
                //   'Country: ',
                //   style: theme.textTheme.bodySmall,
                // ).tr(),
                Consumer<UserInformationViewModel>(
                  builder: (context, value, child) => Row(
                    children: [
                      Text(
                        value.getCountryName == ''
                            ? 'Unselected'
                            : value.getCountryName,
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: blueColor),
                      ).tr(),
                      IconButton(
                        onPressed: () {
                          showCountryPicker(
                              context: context,
                              onSelect: (country) {
                                value.setCountry(country.name);
                              });
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
