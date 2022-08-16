import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/models/sign_by_google_model.dart';
import 'package:home_workout_app/view_models/Register%20View%20Model/sign_by_google_view_model.dart';
import 'package:home_workout_app/view_models/start_view_model.dart';
import 'package:home_workout_app/views/sign%20in%20view/sigin_view.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class StartView extends StatefulWidget {
  StartView({Key? key}) : super(key: key);

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  late VideoPlayerController videoController;
  TextEditingController c_nameController = TextEditingController(text: '');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      videoController = VideoPlayerController.asset("assets/videos/intro.mp4")
        ..initialize().then((value) {
          setState(() {});
        });

      // videoController.setVolume(0);
      videoController.setLooping(true);
      videoController.addListener(() {
        // setState(() {});  //TODO://if you face some problem in it add it
      });
      videoController.play();
    } catch (e) {
      print('intial video player errooor: $e');
    }
  }

  FirebaseMessaging _firebaseMessage =
      FirebaseMessaging.instance; //TODO: delete

  void firebaseTrigger() async {
    //TODO: delete
    // _firebaseMessage.configure(
    //   onLaunch:
    // )
    print(
        'objeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeect');
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(
          'gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');

      print(event.notification!.body);
      print('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.data);
      if (message.data['page'] == 'Second Screen') print('wooooooooorking');
      //navigate
      print('Message clicked!');
      // Map<String, dynamic> mm = message.;
      print(message.data);
      print(
          'gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print("onBackgroundMessage: $message");
    });
  }

  @override
  void dispose() {
    super.dispose();

    try {
      videoController.dispose();
    } catch (e) {
      print('dispose video player errooor: $e');
    }
  }

//TODO: video not working after out and reopen app (solved)
  // @override
  // void didUpdateWidget(covariant StartView oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //    videoController = VideoPlayerController.asset("assets/videos/intro.mp4")
  //     ..initialize().then((value) {
  //       setState(() {});
  //     });

  //   videoController.setVolume(0);
  //   videoController.setLooping(true);
  //   videoController.addListener(() {
  //     setState(() {});
  //   });
  //   videoController.play();
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
        fit: StackFit.expand,
        children: [
          Container(
            // decoration: BoxDecoration(),
            width: double.infinity,
            child: videoController.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.fill,
                    // alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: videoController.value.size.width,
                      height: videoController.value.size.height,
                      child: AspectRatio(
                        child: VideoPlayer(videoController),
                        aspectRatio: videoController.value.aspectRatio,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.white, //orangeColor.withOpacity(0.5),
                    // child: CustomLoading(),
                  ),
          ),
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Center(
                          child: Text(
                            'Vigor'.tr(),
                            style: TextStyle(
                                color: orangeColor,
                                fontSize: 55,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: mq.size.width * 0.05,
                      ),
                      Container(
                        child: Image(
                          height: mq.size.height * 0.3,
                          width: mq.size.width * 0.3,
                          //  fit: BoxFit.fill,
                          color: orangeColor,
                          image:
                              const AssetImage('assets/images/Vigor logo.png'),
                          //   filterQuality: FilterQuality.high,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mq.size.height * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '"OUR'.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'JosefinSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: ' BODIES '.tr(),
                              style: theme.textTheme.bodyMedium),
                          TextSpan(
                            text: 'ARE OUR GARDENS,'.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'JosefinSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '\n'.tr(),
                          ),
                          TextSpan(
                            text: 'TO WHICH OUR WILLS ARE OUR GARDENERS"'.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'JosefinSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '\n'.tr(),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: 'WILLIAM SHAKESPARE'.tr(),
                            style: TextStyle(
                                fontFamily: 'JosefinSans',
                                color: orangeColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.size.height * 0.1,
                  ),
                  Column(
                    children: [
                      SizedBox(height: mq.size.height * 0.01),
                      Container(
                        height: 40,
                        width: 110,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            // shape: StadiumBorder(),
                            side: BorderSide(width: 1, color: orangeColor),
                            //   elevation: 55,
                            backgroundColor: Colors.white.withOpacity(0.01),
                            //orangeColor.withOpacity(0.7),
                            primary: orangeColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () {
                            // videoController.pause();
                            Navigator.of(context).pushReplacementNamed(
                              '/signin',
                            );
                            // videoController.play();
                          },
                          child: Text(
                            'Sign in'.tr(),
                            style: TextStyle(
                                color: orangeColor,
                                //Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: mq.size.height * 0.05),
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
                      SizedBox(height: mq.size.height * 0.07),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: mq.size.width * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Consumer<StartViewModel>(
                                builder: ((context, value, _) => Container(
                                      child: value.googleButton
                                          ? IconButton(
                                              onPressed: () async {
                                                final String? access =
                                                    await SignByGoogleViewModel()
                                                        .signIn();
                                                print(
                                                    'ssssssssssssss: $access');
                                                if (access != null &&
                                                    access != '') {
                                                  value
                                                      .changeGoogleButtonState();
                                                  final SignByGoogleModel?
                                                      BackEndMessage =
                                                      await SignByGoogleViewModel()
                                                          .postUserInfo(
                                                              access,
                                                              getFirebaseNotificationToken(),
                                                              '',
                                                              c_nameController
                                                                  .text,
                                                              context.locale ==
                                                                      Locale(
                                                                          'en')
                                                                  ? 'en'
                                                                  : 'ar');
                                                  print(
                                                      'vvvvvvvvvvvvvvvvvvvvvvvvvvvv');
                                                  print(BackEndMessage
                                                      ?.refresh_token);
                                                  final sBar = SnackBar(
                                                      // margin: EdgeInsets.all(8.0),
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          33)),
                                                      content: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              BackEndMessage
                                                                      ?.message ??
                                                                  '')));
                                                  if (BackEndMessage?.message !=
                                                          null &&
                                                      BackEndMessage?.message !=
                                                          '') {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(sBar);
                                                  }
                                                  if (BackEndMessage
                                                          ?.statusCode !=
                                                      null) {
                                                    value
                                                        .changeGoogleButtonState();
                                                  }
                                                  if (BackEndMessage
                                                              ?.statusCode ==
                                                          201 ||
                                                      BackEndMessage
                                                              ?.statusCode ==
                                                          450) {
                                                    c_nameController.clear();
                                                    try {
                                                      sharedPreferences.setBool(
                                                          "registered", true);
                                                      sharedPreferences.setBool(
                                                          "is_verified", true);
                                                      if (BackEndMessage!
                                                              .is_info ==
                                                          false) {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                '/userinfo');
                                                      } else {
                                                        Navigator.of(context)
                                                            .pushNamedAndRemoveUntil(
                                                                '/home',
                                                                (route) =>
                                                                    false);
                                                      }
                                                    } catch (e) {
                                                      print(
                                                          'navigate to userinfo error: $e');
                                                    }
                                                  } else if (BackEndMessage
                                                          ?.statusCode ==
                                                      250) {
                                                    Navigator.of(context)
                                                        .pushNamed(
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
                            //           'code':
                            //               'BackEndMessage.forgetPasswordCode'
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
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
