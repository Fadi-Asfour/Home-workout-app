import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/sign_by_google_model.dart';
import 'package:home_workout_app/view_models/Register%20View%20Model/sign_by_google_view_model.dart';
import 'package:home_workout_app/view_models/Register%20View%20Model/sign_in_view_model.dart';
import 'package:home_workout_app/models/sign_in_model.dart';
import 'package:home_workout_app/views/otp_view.dart';

import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formGlobalKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController c_nameController = TextEditingController(text: '');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FirebaseMessaging.instance
    //     .getToken()
    //     .then((value) => print("firebase tooooooooken: $value"));
    // firebaseTrigger();
  }

  // FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;

  // void firebaseTrigger() async {
  //   print(
  //       'objeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeect');
  //   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  //     print("message recieved");
  //     print(
  //         'gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');

  //     print(event.notification!.body);
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     print(message.data);
  //     print(message);
  //     if (message.data['page'] == 'Home Screen') {
  //       print('wooooooooorking');
  //       print(message.data['page']);
  //       Navigator.of(context).pushNamed('/home');
  //       //navigate

  //     }
  //     print('Message clicked!');
  //     print(message.data);
  //     print(
  //         'gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');
  //   });
  //   // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
  //   //   print("onBackgroundMessage: $message");
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        // floatingActionButton: FloatingActionButton.extended(
        //     // focusColor: orangeColor,
        //     // hoverColor: orangeColor,
        //     // splashColor: orangeColor,
        //     elevation: 0,
        //     icon: Icon(
        //       Icons.skip_next,
        //       color: blueColor,
        //     ),
        //     onPressed: () {}, //TODO:
        //     backgroundColor: Colors.white.withOpacity(0),
        //     label: Text(
        //       'Skip',
        //       style: TextStyle(
        //         color: blueColor,
        //         fontSize: 20,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     )),
        body: Stack(
          children: [
            Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
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
                                    width: 380,
                                    decoration: BoxDecoration(
                                        color: Colors.white70.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: TextFormField(
                                      // maxLength: 25,
                                      controller: emailController,
                                      validator: (value) {
                                        return signInViewModel().checkEmail(
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
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50),
                                      ],
                                      style: TextStyle(
                                          color: blueColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      keyboardType: TextInputType.emailAddress,

                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  SizedBox(
                                    height: mq.size.height * 0.03,
                                  ),
                                  Container(
                                      width: 380,
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.white70.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Consumer<signInViewModel>(
                                          builder: ((context, value, _) =>
                                              TextFormField(
                                                controller: passwordController,
                                                validator: (value) {
                                                  return signInViewModel()
                                                      .checkPassword(
                                                          value.toString(),
                                                          context.locale ==
                                                                  Locale('en')
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
                                                            Provider.of<signInViewModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changePasswordobscure();
                                                          },
                                                          icon: Icon(
                                                            Provider.of<signInViewModel>(
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
                                                            signInViewModel>(
                                                        context)
                                                    .obscurePassword,
                                                textInputAction:
                                                    TextInputAction.done,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      50),
                                                ],
                                              )))),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: mq.size.height * 0.01,
                            ),
                            TextButton(
                                //TODO:
                                onPressed: () {
                                  try {
                                    Navigator.of(context).pushNamed(
                                      '/forgetPassword',
                                    );
                                  } catch (e) {
                                    print(
                                        'navigate to forget password   error: $e');
                                  }
                                },
                                child: Text(
                                  'Forgot password?'.tr(),
                                  style: theme.textTheme.bodySmall,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: mq.size.height * 0.05),
                      Consumer<signInViewModel>(
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
                                            print(
                                                'firebase token : ${getFirebaseNotificationToken()}');
                                            final SignInModel BackEndMessage =
                                                await signInViewModel()
                                                    .postUserInfo(
                                                        //TODO:
                                                        emailController.text,
                                                        passwordController.text,
                                                        getFirebaseNotificationToken(),
                                                        '',
                                                        c_nameController.text,
                                                        context.locale ==
                                                                Locale('en')
                                                            ? 'en'
                                                            : 'ar');
                                            print(BackEndMessage);
                                            print(BackEndMessage.refresh_token);
                                            // if (BackEndMessage.message !=
                                            //         null &&
                                            //     BackEndMessage.message != '') {
                                            //   showSnackbar(
                                            //       Text(BackEndMessage.message
                                            //           .toString()),
                                            //       context);
                                            // }
                                            final sBar = SnackBar(
                                                // margin: EdgeInsets.all(8.0),
                                                padding: EdgeInsets.all(8.0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            33)),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(BackEndMessage
                                                            .message ??
                                                        '')));
                                            if (BackEndMessage.message !=
                                                    null &&
                                                BackEndMessage.message != '') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(sBar);
                                            }
                                            if (BackEndMessage.statusCode !=
                                                null) {
                                              value.changeLogButtonState();
                                            }

                                            if (BackEndMessage.statusCode == 201 ||
                                                BackEndMessage.statusCode ==
                                                    450 ||
                                                BackEndMessage.statusCode ==
                                                    250) {
                                              c_nameController.clear();
                                              try {
                                                if (BackEndMessage.statusCode ==
                                                        201 &&
                                                    BackEndMessage
                                                            .is_verified ==
                                                        true) {
                                                  sharedPreferences.setBool(
                                                      "registered", true);
                                                  if (BackEndMessage.is_info ==
                                                      true) {
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            '/home',
                                                            (route) => false);
                                                  } else {
                                                    Navigator.of(context)
                                                        .pushNamed('/userinfo');
                                                  }
                                                } else {
                                                  Navigator.of(context)
                                                      .pushNamed('/otp',
                                                          arguments: {
                                                        'state': (BackEndMessage
                                                                        .statusCode ==
                                                                    201 ||
                                                                BackEndMessage
                                                                        .statusCode ==
                                                                    450)
                                                            ? 'sign 201'
                                                            : 'sign 250'
                                                      });
                                                }
                                              } catch (e) {
                                                print(
                                                    'navigate to otp error: $e');
                                              }
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Log in'.tr(),
                                          style: TextStyle(
                                              color: orangeColor,
                                              //Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : bigLoader(color: orangeColor),
                              ))),
                      SizedBox(height: mq.size.height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?'.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.normal),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                  '/signup',
                                );
                              },
                              child: Text(
                                'Sign up here'.tr(),
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
                  SizedBox(height: mq.size.height * 0.05),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: mq.size.width * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Consumer<signInViewModel>(
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
                        //   //TODO: DELETE OR ADD
                        //   onPressed: () {
                        //     Navigator.of(context).pushReplacementNamed(
                        //         '/resetPassword',
                        //         arguments: {
                        //           'code': 'BackEndMessage.forgetPasswordCode'
                        //         });
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
            )
          ],
        ),
      ),
    );
  }
}
