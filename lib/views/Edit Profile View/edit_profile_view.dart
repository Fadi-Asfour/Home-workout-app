// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/view_models/edit_profile_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../view_models/user_information_view_model.dart';
import '../Home View/home_view_widgets.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  GlobalKey<FormState> nameKey = GlobalKey();
  GlobalKey<FormState> hwKey = GlobalKey();

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmNewPassword = TextEditingController();

  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<EditProfileViewModel>(context, listen: false)
          .setInitialData(context);

      final user =
          Provider.of<ProfileViewModel>(context, listen: false).getUserData;
      fnameController.text = user.fname;
      lnameController.text = user.lname;
      bioController.text = user.bio;
      heightController.text = user.height.toString();
      weightController.text = user.weight.toString();
      Provider.of<UserInformationViewModel>(context, listen: false)
          .ChangeHeightUnit(user.heightUnit);
      Provider.of<UserInformationViewModel>(context, listen: false)
          .ChangeWeightUnit(user.weightUnit);
      Provider.of<EditProfileViewModel>(context, listen: false)
          .changeCountry(user.countryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AddressText(title: 'Personal information:'),
            Center(
              child: Consumer2<EditProfileViewModel, ProfileViewModel>(
                builder: (context, value, user, child) => CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: value.getUserImage.path != ''
                      ? FileImage(File(value.getUserImage.path))
                      : NetworkImage(user.getUserData.imageUrl)
                          as ImageProvider,
                  onBackgroundImageError: (child, stacktrace) =>
                      const LoadingContainer(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: user.getUserData.roleId == 2
                              ? orangeColor
                              : (user.getUserData.roleId == 3
                                  ? blueColor
                                  : Colors.transparent),
                          width: 2),
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              child: Text(
                'Change profile photo',
                style: theme.textTheme.bodySmall!.copyWith(color: blueColor),
              ).tr(),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Text(
                      'Change profile photo from:',
                      style:
                          theme.textTheme.bodySmall!.copyWith(color: blueColor),
                    ).tr(),
                    actions: [
                      TextButton(
                        child: Text(
                          'Gallery',
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: blueColor),
                        ).tr(),
                        onPressed: () async {
                          await Provider.of<EditProfileViewModel>(context,
                                  listen: false)
                              .changePhoto(ImageSource.gallery);
                          Navigator.pop(ctx);
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Camera',
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: blueColor),
                        ).tr(),
                        onPressed: () async {
                          await Provider.of<EditProfileViewModel>(context,
                                  listen: false)
                              .changePhoto(ImageSource.camera);
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            Form(
              key: nameKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 15),
                    child: TextFormField(
                      maxLines: 7,
                      maxLength: 200,
                      controller: bioController,
                      validator: (value) {},
                      onSaved: (val) {},
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: FittedBox(child: const Text('Bio').tr()),
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
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: fnameController,
                            validator: (value) {
                              // if (RegExp('[a-zA-Z]+[^0-9]').hasMatch(value!) ==
                              //     false) {
                              //   return 'invalid name';
                              // }
                            },
                            onSaved: (val) {},
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              label: FittedBox(
                                  child: const Text('First name').tr()),
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: lnameController,
                            validator: (value) {},
                            onSaved: (val) {},
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              label: FittedBox(
                                  child: const Text('Last name').tr()),
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
                ],
              ),
            ),
            Form(
              key: hwKey,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
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
                          suffixIcon: Consumer<EditProfileViewModel>(
                            builder: (context, value, child) => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    log('here');
                                    if (value.getHeight != Units.cm) {
                                      value.ChangeHeightUnit(Units.cm);
                                    }
                                  },
                                  child: Text(
                                    'cm',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        fontSize: value.getHeight == Units.cm
                                            ? 17
                                            : 15,
                                        color: value.getHeight == Units.cm
                                            ? orangeColor
                                            : greyColor),
                                  ).tr(),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (value.getHeight != Units.ft) {
                                      value.ChangeHeightUnit(Units.ft);
                                    }
                                  },
                                  child: Text(
                                    'ft',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        fontSize: value.getHeight == Units.ft
                                            ? 17
                                            : 15,
                                        color: value.getHeight == Units.ft
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
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
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
                          suffixIcon: Consumer<EditProfileViewModel>(
                            builder: (context, value, child) => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (value.getWeight != Units.kg) {
                                      value.ChangeWeightUnit(Units.kg);
                                    }
                                  },
                                  child: Text(
                                    'Kg',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        fontSize: value.getWeight == Units.kg
                                            ? 15
                                            : 12,
                                        color: value.getWeight == Units.kg
                                            ? orangeColor
                                            : greyColor),
                                  ).tr(),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (value.getWeight != Units.lb) {
                                      value.ChangeWeightUnit(Units.lb);
                                    }
                                  },
                                  child: Text(
                                    'lb',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        fontSize: value.getWeight == Units.lb
                                            ? 17
                                            : 15,
                                        color: value.getWeight == Units.lb
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Gender: ',
                    style: theme.textTheme.bodySmall,
                  ).tr(),
                  const SizedBox(
                    width: 5,
                  ),
                  Consumer<EditProfileViewModel>(
                    builder: (context, value, child) => DropdownButton<Gender>(
                      autofocus: true,
                      elevation: 0,
                      underline: const SizedBox(),
                      focusColor: Colors.transparent,
                      iconEnabledColor: blueColor,
                      iconDisabledColor: blueColor,
                      borderRadius: BorderRadius.circular(15),
                      value: value.getGender,
                      items: Gender.values
                          .map(
                            (e) => DropdownMenuItem<Gender>(
                              value: e,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  e.name,
                                  style: theme.textTheme.bodySmall!
                                      .copyWith(color: blueColor, fontSize: 15),
                                ).tr(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (Gender? newGender) {
                        value.setGender(newGender!);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Birthdate: ',
                    style: theme.textTheme.bodySmall,
                  ).tr(),
                  Consumer<EditProfileViewModel>(
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(value.getBirthdate),
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: blueColor),
                        ),
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
                ],
              ),
            ),
            AddressText(title: 'Account information:'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Country: ',
                    style: theme.textTheme.bodySmall,
                  ).tr(),
                  Consumer<EditProfileViewModel>(
                    builder: (context, value, child) => Row(
                      children: [
                        Text(
                          value.getCountry,
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: blueColor),
                        ),
                        IconButton(
                          onPressed: () {
                            showCountryPicker(
                                context: context,
                                onSelect: (country) {
                                  value.changeCountry(country.name);
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
            ),
            if (sharedPreferences.getBool('googleProvider') == false)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/changeEmail');
                    },
                    child: ListTile(
                      title: Text(
                        'Change email',
                        style: theme.textTheme.bodySmall,
                      ).tr(),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: blueColor,
                        size: 15,
                      ),
                    )),
              ),
            if (sharedPreferences.getBool('googleProvider') == false)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/changePassword');
                    },
                    child: ListTile(
                      title: Text(
                        'Change password',
                        style: theme.textTheme.bodySmall,
                      ).tr(),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: blueColor,
                        size: 15,
                      ),
                    )),
              ),
            Consumer<EditProfileViewModel>(
              builder: (context, value, child) => value.getIsLoading
                  ? bigLoader(color: orangeColor)
                  : ElevatedButton(
                      onPressed: () async {
                        //nameKey.currentState!.validate();
                        await Provider.of<EditProfileViewModel>(context,
                                listen: false)
                            .editProfile(
                          fnameController.text.trim(),
                          lnameController.text.trim(),
                          value.getUserImage,
                          bioController.text.trim(),
                          heightController.text.trim(),
                          weightController.text.trim(),
                          value.getGender,
                          value.getBirthdate,
                          context,
                          value.getCountry,
                        );
                      },
                      child: const Text(
                        'Save changes',
                      ).tr(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressText extends StatelessWidget {
  AddressText({required this.title, Key? key}) : super(key: key);

  String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: context.locale == Locale('en')
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
        child: Text(
          title,
          style: theme.textTheme.bodySmall!
              .copyWith(color: greyColor, decoration: TextDecoration.underline),
        ).tr(),
      ),
    );
  }
}
