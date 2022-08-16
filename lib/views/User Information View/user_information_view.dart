import 'package:flutter/material.dart';
import 'package:home_workout_app/view_models/user_information_view_model.dart';
import 'package:home_workout_app/views/User%20Information%20View/details_page1.dart';
import 'package:home_workout_app/views/User%20Information%20View/details_page2.dart';
import 'package:provider/provider.dart';

class UserInformationView extends StatelessWidget {
  UserInformationView({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formkey = GlobalKey();

  final PageController _pageController = PageController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Details1Page(
                    heightController: heightController,
                    weightController: weightController,
                    formkey: _formkey,
                    nextFunction: () {
                      Provider.of<UserInformationViewModel>(context,
                              listen: false)
                          .checkDetails1Value(
                        _formkey,
                        _pageController,
                        context,
                        heightController.text.trim(),
                        weightController.text.trim(),
                      );
                    }),
                Details2Page(saveFunction: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
