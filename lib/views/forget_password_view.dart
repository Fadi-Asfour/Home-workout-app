import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/main.dart';
import 'package:home_workout_app/view_models/forget_password_view_model.dart';
import 'package:provider/provider.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController c_nameController =
      TextEditingController(text: ''); //TODO: add cname
  @override
  Widget build(BuildContext context) {
    // final routeArg =
    // ModalRoute.of(context)?.settings.arguments as Map<String, Object>;

    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Image(
          height: mq.size.height * 0.1,
          width: double.infinity,
          fit: BoxFit.fill,
          image: const AssetImage('assets/images/wave_background.png'),
          filterQuality: FilterQuality.high,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: mq.size.height * 0.2,
                  width: mq.size.width * 0.2,
                  child: Image.asset(
                    'assets/images/lock.png',
                    // color: orangeColor,
                  ),
                  // Icon(
                  //   Icons.message,
                  //   color: orangeColor,
                  //   size: (mq.size.height * 0.1 + mq.size.width * 0.1) / 2,
                  // ),
                ),
                Container(
                  child: Text(
                    ' Forgot your password? '.tr(),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                // Container(
                //   child: Text(
                //     ' Please enter your Email ',
                //     style: theme.textTheme.bodyMedium,
                //   ),
                // ),
                SizedBox(
                  height: 10,
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: mq.size.height * 0.1,
                            vertical: mq.size.width * 0.03),
                        child: Container(
                          width: 380,
                          decoration: BoxDecoration(
                              color: Colors.white70.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            width: 380,
                            decoration: BoxDecoration(
                                color: Colors.white70.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15)),
                            child: TextFormField(
                              // maxLength: 25,
                              controller: emailController,
                              validator: (value) {
                                return ForgetPasswordViewModel().checkEmail(
                                    value.toString(),
                                    context.locale == Locale('en')
                                        ? 'en'
                                        : 'ar');
                              },
                              decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: blueColor, width: 1.5),
                                  borderRadius: BorderRadius.all(
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

                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                Container(
                  height: 40,
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formGlobalKey.currentState!.validate()) {
                        formGlobalKey.currentState!.save();
                        // use the email provided here

                        final BackEndMessage = await ForgetPasswordViewModel()
                            .postEmail(
                                emailController.text,
                                c_nameController.text == null
                                    ? ''
                                    : c_nameController.text,
                                context.locale == Locale('en') ? 'en' : 'ar');
                        print(BackEndMessage);
                        final sBar = SnackBar(
                            // margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(33)),
                            content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(BackEndMessage.message ?? '')));
                        if (BackEndMessage.message != null &&
                            BackEndMessage.message != '') {
                          ScaffoldMessenger.of(context).showSnackBar(sBar);
                        }
                        if (BackEndMessage.statusCode == 201) {
                          String email = emailController.text;
                          emailController.clear();
                          c_nameController.clear();
                          try {
                            Navigator.of(context).pushNamed('/otp', arguments: {
                              'state': 'forget password',
                              'email': email
                            });
                          } catch (e) {
                            print(
                                'navigate from forget password to otp error: $e');
                          }
                        }
                      }
                    },
                    child: Text('Send'.tr()),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Don\'t receive the code?',
                //       style: TextStyle(
                //           color: blueColor,
                //           fontSize: 17,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     TextButton(
                //         onPressed: () async {
                //           // final BackEndMessage = await otpViewModel()
                //           //     .postUserInfo(
                //           //         otpController.text,
                //           //         c_nameController.text == null
                //           //             ? ''
                //           //             : c_nameController.text,
                //           //         (routeArg['state'] == 'sign 201' ||
                //           //                 routeArg['state'] == 'update email')
                //           //             ? '/emailVerfiy/reget'
                //           //             : '/user/recover/reget');
                //         },
                //         child: Text(
                //           'Resend again',
                //           style: theme.textTheme.bodySmall,
                //         )),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
