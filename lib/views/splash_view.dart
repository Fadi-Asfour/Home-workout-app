import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/Api%20services/home_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/view_models/Home%20View%20Model/mobile_home_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(
        'uuuuugggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');
    getFirebaseNotificationToken();
    print(getFirebaseNotificationToken());
    Future.delayed(const Duration(seconds: 1)).then((value) {
      firebaseTrigger();

      //HomeAPI().getSummaryInfo(lang: getLang(context));

      if (sharedPreferences.getBool('registered') == true &&
          sharedPreferences.getBool('is_info') == true &&
          ((sharedPreferences.getBool('is_verified') == true) ||
              (sharedPreferences.getBool('googleProvider') == true))) {
        print(sharedPreferences.getBool('is_info'));

        ////remove here if error
        Future.delayed(Duration.zero).then((_) {
          Provider.of<MobileHomeViewModel>(context, listen: false)
              .getSummaryData(lang: getLang(context), context: context);
          Provider.of<ProfileViewModel>(context, listen: false)
              .setCurrentUserData(context);
        });
        ////remove here if error
        Navigator.pushReplacementNamed(context, '/home');
      } else if (sharedPreferences.getBool('registered') == true &&
          sharedPreferences.getBool('is_verified') != true &&
          sharedPreferences.getBool('googleProvider') != true) {
        Navigator.pushReplacementNamed(context, '/signin');
      } else if ((sharedPreferences.getBool('registered') == true ||
              sharedPreferences.getBool('googleProvider') == true) &&
          sharedPreferences.getBool('is_info') != true) {
        Navigator.pushReplacementNamed(context, '/userinfo');
      } else {
        Navigator.pushReplacementNamed(context, '/start');
      }
    });
  }

  FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;

  void firebaseTrigger() async {
    try {
      print(
          'objeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeect');
      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        print("message recieved");
        print(
            'gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');

        print(event.notification!.body);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print(message.data);
        print(message);
        if (message.data['page'] == 'Home Screen') {
          print('wooooooooorking');
          print(message.data['page']);
          if (sharedPreferences.getBool('registered') == true &&
              sharedPreferences.getBool('is_info') == true) {
            ////remove here if error
            Future.delayed(Duration.zero).then((_) {
              Provider.of<MobileHomeViewModel>(context, listen: false)
                  .getSummaryData(lang: getLang(context), context: context);
              Provider.of<ProfileViewModel>(context, listen: false)
                  .setCurrentUserData(context);
            });
            ////remove here if error
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
        print('Message clicked!');
        print(message.data);
        print(
            'gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');
      });
      // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      //   print("onBackgroundMessage: $message");
      // });
    } catch (e) {
      print('firebase error when go to specific screen $e ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orangeColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image(
                width: 150,
                height: 150,
                image: const AssetImage("assets/images/Vigor logo.png"),
                // color: blueColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                  minHeight: 1, backgroundColor: orangeColor, color: blueColor),
            )
          ],
        ),
      ),
    );
  }
}
