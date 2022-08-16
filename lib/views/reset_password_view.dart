import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/Reset_password_model.dart';
import 'package:home_workout_app/view_models/reset_password_view_model.dart';

import 'package:provider/provider.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({Key? key}) : super(key: key);
  final formGlobalKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confimPasswordController = TextEditingController();
  TextEditingController c_nameController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final routeArg =
        ModalRoute.of(context)?.settings.arguments as Map<String, Object>;

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
                ))),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mq.size.height * 0.2,
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
                                child: Column(children: [
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
                                        return ResetPasswordViewModel()
                                            .checkEmail(
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
                                      child: Consumer<ResetPasswordViewModel>(
                                          builder: ((context, value, _) =>
                                              TextFormField(
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      30),
                                                ],
                                                controller: passwordController,
                                                validator: (value) {
                                                  return ResetPasswordViewModel()
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
                                                            Provider.of<ResetPasswordViewModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changePasswordobscure();
                                                          },
                                                          icon: Icon(
                                                            Provider.of<ResetPasswordViewModel>(
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
                                                            ResetPasswordViewModel>(
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
                                      child: Consumer<ResetPasswordViewModel>(
                                          builder: ((context, value, _) =>
                                              TextFormField(
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      30),
                                                ],
                                                controller:
                                                    confimPasswordController,
                                                validator: (value) {
                                                  return ResetPasswordViewModel()
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
                                                            Provider.of<ResetPasswordViewModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changeConfirmPasswordobscure();
                                                          },
                                                          icon: Icon(
                                                            Provider.of<ResetPasswordViewModel>(
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
                                                            ResetPasswordViewModel>(
                                                        context)
                                                    .obscureConfirmPassword,
                                                textInputAction:
                                                    TextInputAction.done,
                                              )))),
                                ])),
                            SizedBox(
                              height: mq.size.height * 0.03,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: mq.size.height * 0.05),
                      Container(
                        height: 40,
                        width: 110,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            // shape: StadiumBorder(),
                            side: BorderSide(width: 1, color: orangeColor),
                            // elevation: 55,
                            backgroundColor: Colors.white.withOpacity(0.01),
                            //orangeColor.withOpacity(0.7),
                            primary: orangeColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () async {
                            if (formGlobalKey.currentState!.validate()) {
                              formGlobalKey.currentState!.save();
                              // use the email provided here

                              final ResetPasswordModel BackEndMessage =
                                  await ResetPasswordViewModel().postUserInfo(
                                      emailController.text,
                                      passwordController.text,
                                      confimPasswordController.text,
                                      c_nameController.text,
                                      routeArg['code'].toString(),
                                      context.locale == Locale('en')
                                          ? 'en'
                                          : 'ar');
                              print(routeArg['code'].toString());
                              print(BackEndMessage);
                              final sBar = SnackBar(
                                  // margin: EdgeInsets.all(8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(33)),
                                  content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          Text(BackEndMessage.message ?? '')));
                              if (BackEndMessage.message != null &&
                                  BackEndMessage.message != '') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(sBar);
                              }

                              print(BackEndMessage.statusCode);
                              if (BackEndMessage.statusCode == 201 ||
                                  BackEndMessage.statusCode == 450) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/signin', (route) => false);

                                emailController.clear();
                                passwordController.clear();
                                confimPasswordController.clear();
                                if (c_nameController != null)
                                  c_nameController.clear();
                              }
                            }
                          },
                          child: Text(
                            'Save'.tr(),
                            style: TextStyle(
                                color: orangeColor,
                                //Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
