// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:home_workout_app/view_models/Home%20View%20Model/web_home_view_model.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class WebHomeView extends StatefulWidget {
  const WebHomeView({Key? key}) : super(key: key);

  @override
  State<WebHomeView> createState() => _WebHomeViewState();
}

class _WebHomeViewState extends State<WebHomeView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    print(mq.size.width);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: mq.size.width > 600
                ? SizedBox(
                    width: mq.size.width * 0.2,
                    child: TextField(
                      cursorColor: blueColor,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: blueColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: blueColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: blueColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: blueColor),
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) => AlertDialog(
                          backgroundColor: greyColor.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          content: SizedBox(
                            width: mq.size.width * 0.5,
                            child: TextField(
                              cursorColor: blueColor,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: blueColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: blueColor, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: blueColor, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: blueColor, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                      color: blueColor,
                    ),
                  ),
          ),
        ],
        title: Consumer<WebHomeViewModel>(
          builder: (context, value, child) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                onHover: (hovering) {
                  value.setScale('Logo', hovering);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: blueColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Vigor',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      AnimatedScale(
                        duration: Duration(milliseconds: 200),
                        scale: value.getLogoScale,
                        child: SvgPicture.asset(
                          'assets/images/vigorlogo.svg',
                          semanticsLabel: 'vigor Logo',
                          height: 40,
                          width: 40,
                          color: orangeColor,
                          // matchTextDirection: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              TextButton(
                onHover: (hovering) {
                  value.setScale('Home', hovering);
                },
                onPressed: () {
                  value.changeSelectedPage('Home');
                },
                child: AnimatedScale(
                  scale:
                      value.selectedPage == 'Home' ? 1.2 : value.getHomeScale,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    'Home',
                    style: theme.textTheme.bodySmall!.copyWith(
                        decorationThickness: 2,
                        decoration: value.selectedPage == 'Home'
                            ? TextDecoration.underline
                            : TextDecoration.none),
                  ),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              TextButton(
                onPressed: () {
                  value.changeSelectedPage('Posts');
                },
                onHover: (hovering) {
                  value.setScale('Posts', hovering);
                },
                child: AnimatedScale(
                  scale:
                      value.selectedPage == 'Posts' ? 1.2 : value.getPostsScale,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    'Posts',
                    style: theme.textTheme.bodySmall!.copyWith(
                        decorationThickness: 2,
                        decoration: value.selectedPage == 'Posts'
                            ? TextDecoration.underline
                            : TextDecoration.none),
                  ),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              TextButton(
                onPressed: () {
                  value.changeSelectedPage('Profile');
                },
                onHover: (hovering) {
                  value.setScale('Profile', hovering);
                },
                child: AnimatedScale(
                  scale: value.selectedPage == 'Profile'
                      ? 1.2
                      : value.getProfileScale,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    'Profile',
                    style: theme.textTheme.bodySmall!.copyWith(
                        decorationThickness: 2,
                        decoration: value.selectedPage == 'Profile'
                            ? TextDecoration.underline
                            : TextDecoration.none),
                  ),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
            ],
          ),
        ),
      ),
      body: Provider.of<WebHomeViewModel>(context, listen: true).getPage(),
    );
  }
}
