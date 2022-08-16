import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/sign_by_google_model.dart';
import 'package:home_workout_app/models/sign_up_model.dart';
import 'package:home_workout_app/view_models/Register%20View%20Model/sign_by_google_view_model.dart';
import 'package:home_workout_app/view_models/Register%20View%20Model/sign_up_view_model.dart';
import 'package:home_workout_app/views/otp_view.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confimPasswordController = TextEditingController();
  TextEditingController c_nameController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    // color: Color.fromARGB(251, 133, 0, 78),
                    image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/login.jpg',
                  ),
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.darken),
                  //   color: Colors.black.withOpacity(0.001),
                  fit: BoxFit.cover,
                ))
                //  child: Image.asset(
                //               'assets/images/MainPageExercise.gif',
                //              // color: Colors.black.withOpacity(0.001),
                //               fit: BoxFit.fill,
                //             ),
                ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mq.size.height * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 420,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white70.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: mq.size.height * 0.02,
                            ),
                            Form(
                              key: formGlobalKey,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 0,
                                        width: 0,
                                        child: TextFormField(
                                          controller: c_nameController,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(5),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: mq.size.width * 0.43,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white70.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                15),
                                          ],
                                          controller: firstNameController,
                                          validator: (value) {
                                            return SignUpViewModel()
                                                .checkFirstName(
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
                                            labelText: 'First name'.tr(),
                                            labelStyle: TextStyle(
                                                color: orangeColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            prefixIcon: Icon(
                                              CupertinoIcons.profile_circled,
                                              color: blueColor,
                                              size: 33,
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.name,
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                      SizedBox(
                                        width: mq.size.width * 0.03,
                                      ),
                                      Container(
                                        width: mq.size.width * 0.43,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white70.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                15),
                                          ],
                                          controller: lastNameController,
                                          validator: (value) {
                                            return SignUpViewModel()
                                                .checkLastName(
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
                                            labelText: 'Last name'.tr(),
                                            labelStyle: TextStyle(
                                                color: orangeColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            prefixIcon: Icon(
                                              CupertinoIcons.profile_circled,
                                              color: blueColor,
                                              size: 33,
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.name,
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: mq.size.height * 0.02,
                                  ),
                                  Container(
                                    width: 400,
                                    decoration: BoxDecoration(
                                        color: Colors.white70.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(30),
                                      ],
                                      controller: emailController,
                                      validator: (value) {
                                        return SignUpViewModel().checkEmail(
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
                                        labelText: 'Email'.tr(),
                                        labelStyle: TextStyle(
                                            color: orangeColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: blueColor,
                                          size: 33,
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: blueColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  SizedBox(
                                    height: mq.size.height * 0.02,
                                  ),
                                  Container(
                                      width: 400,
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.white70.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Consumer<SignUpViewModel>(
                                          builder: ((context, value, _) =>
                                              TextFormField(
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      30),
                                                ],
                                                controller: passwordController,
                                                validator: (value) {
                                                  return SignUpViewModel()
                                                      .checkPassword(
                                                          value.toString(),
                                                          context.locale ==
                                                                  Locale('en')
                                                              ? 'en'
                                                              : 'ar');
                                                },
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: greyColor,
                                                          width: 1.5),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: orangeColor,
                                                          width: 1.5),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                    labelText: 'Password'.tr(),
                                                    labelStyle: TextStyle(
                                                        color: orangeColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    prefixIcon: Icon(
                                                      Icons
                                                          .lock_outline_rounded,
                                                      color: blueColor,
                                                      size: 33,
                                                    ),
                                                    suffixIcon: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: IconButton(
                                                          onPressed: () {
                                                            Provider.of<SignUpViewModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changePasswordobscure();
                                                          },
                                                          icon: Icon(
                                                            Provider.of<SignUpViewModel>(
                                                                        context)
                                                                    .obscurePassword
                                                                ? Icons
                                                                    .visibility_off
                                                                : Icons
                                                                    .visibility,
                                                            color: blueColor,
                                                            size: 33,
                                                          )),
                                                    )),
                                                style: TextStyle(
                                                    color: blueColor,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                obscureText: Provider.of<
                                                            SignUpViewModel>(
                                                        context)
                                                    .obscurePassword,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onEditingComplete: () {
                                                  // Move the focus to the next node explicitly.
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                },
                                              )))),
                                  SizedBox(
                                    height: mq.size.height * 0.02,
                                  ),
                                  Container(
                                      width: 400,
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.white70.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Consumer<SignUpViewModel>(
                                          builder: ((context, value, _) =>
                                              TextFormField(
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      30),
                                                ],
                                                controller:
                                                    confimPasswordController,
                                                validator: (value) {
                                                  return SignUpViewModel()
                                                      .checkConfirmPassword(
                                                          value.toString(),
                                                          passwordController
                                                              .text,
                                                          context.locale ==
                                                                  Locale('en')
                                                              ? 'en'
                                                              : 'ar');
                                                },
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: greyColor,
                                                          width: 1.5),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: orangeColor,
                                                          width: 1.5),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                    labelText:
                                                        'Confirm password'.tr(),
                                                    labelStyle: TextStyle(
                                                        color: orangeColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    prefixIcon: Icon(
                                                      Icons
                                                          .lock_outline_rounded,
                                                      color: blueColor,
                                                      size: 33,
                                                    ),
                                                    suffixIcon: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: IconButton(
                                                          onPressed: () {
                                                            Provider.of<SignUpViewModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changeConfirmPasswordobscure();
                                                          },
                                                          icon: Icon(
                                                            Provider.of<SignUpViewModel>(
                                                                        context)
                                                                    .obscureConfirmPassword
                                                                ? Icons
                                                                    .visibility_off
                                                                : Icons
                                                                    .visibility,
                                                            color: blueColor,
                                                            size: 33,
                                                          )),
                                                    )),
                                                style: TextStyle(
                                                    color: blueColor,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                obscureText: Provider.of<
                                                            SignUpViewModel>(
                                                        context)
                                                    .obscureConfirmPassword,
                                                textInputAction:
                                                    TextInputAction.done,
                                              )))),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: mq.size.height * 0.01,
                            ),
                            // TextButton(
                            //     onPressed: () {},
                            //     child: Text(
                            //       'Forgot password ?',
                            //       style: theme.textTheme.bodySmall,
                            //     ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: mq.size.height * 0.05),
                      Consumer<SignUpViewModel>(
                        builder: ((context, value, _) => Container(
                              height: 40,
                              width: 110,
                              child: value.logButton
                                  ? OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        // shape: StadiumBorder(),
                                        side: BorderSide(
                                            width: 1, color: orangeColor),
                                        // elevation: 55,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.01),
                                        //orangeColor.withOpacity(0.7),
                                        primary: orangeColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      ),
                                      onPressed: () async {
                                        if (formGlobalKey.currentState!
                                            .validate()) {
                                          formGlobalKey.currentState!.save();
                                          // use the email provided here
                                          value.changeLogButtonState();

                                          final SignUpModel BackEndMessage =
                                              await SignUpViewModel().postUserInfo(
                                                  firstNameController.text,
                                                  lastNameController.text,
                                                  emailController.text,
                                                  passwordController.text,
                                                  confimPasswordController.text,
                                                  getFirebaseNotificationToken(),
                                                  '',
                                                  c_nameController.text,
                                                  context.locale == Locale('en')
                                                      ? 'en'
                                                      : 'ar');
                                          print(BackEndMessage);
                                          final sBar = SnackBar(
                                              // margin: EdgeInsets.all(8.0),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          33)),
                                              content: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      BackEndMessage.message ??
                                                          '')));
                                          if (BackEndMessage.message != null &&
                                              BackEndMessage.message != '') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(sBar);
                                          }
                                          if (BackEndMessage.statusCode !=
                                              null) {
                                            value.changeLogButtonState();
                                          }

                                          print(BackEndMessage.statusCode);
                                          if (BackEndMessage.statusCode ==
                                                  201 ||
                                              BackEndMessage.statusCode ==
                                                  450) {
                                            sharedPreferences.setBool(
                                                "registered", true);
                                            Navigator.of(context)
                                                .pushNamed('/otp', arguments: {
                                              'state': 'sign 201'
                                            });
                                            firstNameController.clear();
                                            lastNameController.clear();
                                            emailController.clear();
                                            passwordController.clear();
                                            confimPasswordController.clear();
                                            if (c_nameController != null)
                                              c_nameController.clear();
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Sign up'.tr(),
                                        style: TextStyle(
                                            color: orangeColor,
                                            //Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : bigLoader(
                                      color: orangeColor,
                                    ),
                            )),
                      ),
                      SizedBox(height: mq.size.height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?'.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.normal),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                  '/signin',
                                );
                              },
                              child: Text(
                                'Sign in here'.tr(),
                                style: theme.textTheme.bodySmall,
                              )),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            height: 20,
                            thickness: 5,
                            // indent: 20,
                            // endIndent: 0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('or'.tr()),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            height: 20,
                            thickness: 5,
                            // indent: 20,
                            // endIndent: 0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mq.size.height * 0.03),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: mq.size.width * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Consumer<SignUpViewModel>(
                            builder: ((context, value, _) => Container(
                                  child: value.googleButton
                                      ? IconButton(
                                          onPressed: () async {
                                            final String? access =
                                                await SignByGoogleViewModel()
                                                    .signIn();
                                            print('ssssssssssssss: $access');
                                            if (access != null &&
                                                access != '') {
                                              value.changeGoogleButtonState();
                                              final SignByGoogleModel?
                                                  BackEndMessage =
                                                  await SignByGoogleViewModel()
                                                      .postUserInfo(
                                                          access,
                                                          getFirebaseNotificationToken(),
                                                          '',
                                                          c_nameController.text,
                                                          context.locale ==
                                                                  Locale('en')
                                                              ? 'en'
                                                              : 'ar');
                                              print(
                                                  'vvvvvvvvvvvvvvvvvvvvvvvvvvvv');
                                              print(BackEndMessage
                                                  ?.refresh_token);
                                              final sBar = SnackBar(
                                                  // margin: EdgeInsets.all(8.0),
                                                  padding: EdgeInsets.all(8.0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              33)),
                                                  content: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(BackEndMessage
                                                              ?.message ??
                                                          '')));
                                              if (BackEndMessage?.message !=
                                                      null &&
                                                  BackEndMessage?.message !=
                                                      '') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(sBar);
                                              }
                                              if (BackEndMessage?.statusCode !=
                                                  null) {
                                                value.changeGoogleButtonState();
                                              }
                                              if (BackEndMessage?.statusCode ==
                                                      201 ||
                                                  BackEndMessage?.statusCode ==
                                                      450) {
                                                emailController.clear();
                                                passwordController.clear();
                                                c_nameController.clear();
                                                try {
                                                  sharedPreferences.setBool(
                                                      "registered", true);
                                                  sharedPreferences.setBool(
                                                      "is_verified", true);
                                                  if (BackEndMessage!.is_info ==
                                                      false) {
                                                    Navigator.of(context)
                                                        .pushNamed('/userinfo');
                                                  } else {
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            '/home',
                                                            (route) => false);
                                                  }
                                                } catch (e) {
                                                  print(
                                                      'navigate to userinfo error: $e');
                                                }
                                              } else if (BackEndMessage
                                                      ?.statusCode ==
                                                  250) {
                                                Navigator.of(context).pushNamed(
                                                    '/otp',
                                                    arguments: {
                                                      'state': 'sign 250'
                                                    });
                                              }
                                            }
                                          },
                                          icon: Image.asset(
                                              'assets/images/google.png'))
                                      : mediumLoader(color: orangeColor),
                                ))),
                        // IconButton(
                        //   onPressed: () {
                        //     // Navigator.of(context).pushReplacementNamed(
                        //     //   '/forgetPassword',
                        //     // );
                        //     // Navigator.of(context).pushReplacementNamed('/otp',
                        //     //     arguments: {'state': 'forget password'});

                        //     Navigator.of(context).pushNamed('/resetPassword',
                        //         arguments: {
                        //           'code': 'BackEndMessage.forgetPasswordCode'
                        //         });
                        //     print(context.locale == Locale('en') ? 'en' : 'ar');
                        //   },
                        //   icon: Image.asset(
                        //     'assets/images/facebook.png',
                        //   ),
                        //   //   iconSize: mq.size.width * 0.01,
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // TextButton(
                        //     onPressed: () {}, //TODO:
                        //     child: Text(
                        //       ' Skip > '.tr(),
                        //       style: theme.textTheme.bodySmall,
                        //     ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         // OutlinedButton(
            //         //   style: OutlinedButton.styleFrom(
            //         //     // shape: StadiumBorder(),
            //         //     side: BorderSide(width: 1, color: orangeColor),
            //         //     // elevation: 55,
            //         //     backgroundColor: Colors.white.withOpacity(0.01),
            //         //     //orangeColor.withOpacity(0.7),
            //         //     primary: orangeColor,
            //         //     shape: RoundedRectangleBorder(
            //         //         borderRadius: BorderRadius.circular(25)),
            //         //   ),
            //         //   onPressed: () {},
            //         //   child: Text('xxx'),
            //         // ),
            //         // ElevatedButton(onPressed: () {}, child: Text('yyy')),
            //       ],
            //     )
            //   ],
            // )
            // ElevatedButton(onPressed: () {}, child: Text('yyy')),
          ],
        ),
      ),
    );
  }
}
