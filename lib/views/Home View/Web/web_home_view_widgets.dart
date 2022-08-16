// ignore_for_file: camel_case_types, curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/views/Home%20View/home_view_widgets.dart';
import 'package:provider/provider.dart';

import '../../../my_flutter_app_icons.dart';
import '../../../view_models/Home View Model/mobile_home_view_model.dart';

class webWorkoutCard extends StatelessWidget {
  webWorkoutCard(
      {required this.publisherName,
      required this.imageUrl,
      required this.exercisesNum,
      required this.min,
      required this.publisherImageUrl,
      required this.workoutName,
      Key? key})
      : super(key: key);

  String publisherName;
  String publisherImageUrl;
  String workoutName;
  String imageUrl;
  int exercisesNum;
  int min;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    return SizedBox(
      width: mq.size.width * 0.95,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(publisherImageUrl),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coach $publisherName',
                    style:
                        theme.textTheme.bodySmall!.copyWith(color: blueColor),
                  ),
                  Text(
                    '6/3/2022 - 5:33 PM',
                    style: theme.textTheme.displaySmall!
                        .copyWith(color: greyColor, fontSize: 10),
                  )
                ],
              )
            ],
          ),
          Expanded(
            child: Container(
              width: mq.size.width * 0.95,
              //height: 400,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: blueColor, width: 2),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress != null
                              ? const LoadingContainer()
                              : child,
                      //width: mq.width * 0.95,
                      height: mq.size.longestSide,
                      fit: BoxFit.cover,
                      image: NetworkImage(imageUrl),
                    ),
                  ),
                  Container(
                    width: mq.size.width * 0.95,
                    height: mq.size.longestSide,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                        color: orangeColor.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FittedBox(
                              child: Text(
                                workoutName,
                                style: theme.textTheme.displaySmall,
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                'Exercises: $exercisesNum',
                                style: theme.textTheme.displaySmall,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.alarm,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                Text(
                                  '$min min',
                                  style: theme.textTheme.displaySmall!
                                      .copyWith(fontSize: 15),
                                )
                              ],
                            ),
                            // FittedBox(
                            //   child: Text(
                            //     'Published by:\ncoach ${e.publisherName}',
                            //     style: theme.textTheme.displaySmall,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class webNormalPostCard extends StatefulWidget {
  webNormalPostCard(
      {required this.coachName,
      required this.coachImageUrl,
      required this.title,
      required this.postImages,
      required this.comments,
      required this.likes,
      required this.currentReactID,
      Key? key})
      : super(key: key);

  String coachName;
  String coachImageUrl;
  List<String> postImages;
  String title;
  Map<String, int> likes;
  List<String> comments;
  String currentReactID;

  @override
  State<webNormalPostCard> createState() => _webNormalPostCardState();
}

class _webNormalPostCardState extends State<webNormalPostCard> {
  final PageController _pageController = PageController();
  int currentPhotoIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController.addListener(() {
      setState(() {
        if (_pageController.page == null)
          currentPhotoIndex = 0;
        else
          currentPhotoIndex = _pageController.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return Center(
      child: Container(
        width: mq.size.width * 0.6,
        height: mq.size.height * 0.65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: blueColor, width: 1.5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.coachImageUrl),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coach ${widget.coachName}',
                      style:
                          theme.textTheme.bodySmall!.copyWith(color: blueColor),
                    ),
                    Text(
                      '6/3/2022 - 5:33 PM',
                      style: theme.textTheme.displaySmall!
                          .copyWith(color: greyColor, fontSize: 10),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                style:
                    theme.textTheme.bodyMedium!.copyWith(color: Colors.black54),
              ),
            ),
            if (widget.postImages.length == 1)
              Expanded(
                child: Image(
                  width: mq.size.width * 0.6,
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.postImages[0],
                  ),
                ),
              ),
            if (widget.postImages.length > 1)
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: IconButton(
                        onPressed: () {
                          _pageController.animateToPage(
                              _pageController.page!.toInt() - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear);
                        },
                        icon: Icon(
                          Icons.arrow_circle_left_rounded,
                          color: orangeColor,
                          size: 25,
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        children: widget.postImages
                            .map(
                              (e) => Image(
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    loadingProgress != null
                                        ? const LoadingContainer()
                                        : child,
                                width: mq.size.width * 0.6,
                                height: mq.size.height * 0.5,
                                fit: BoxFit.contain,
                                image: NetworkImage(e),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: IconButton(
                        onPressed: () {
                          _pageController.animateToPage(
                              _pageController.page!.toInt() + 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear);
                        },
                        icon: Icon(
                          Icons.arrow_circle_right_rounded,
                          color: orangeColor,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  widget.postImages.length > 1
                      ? '${currentPhotoIndex + 1}/${widget.postImages.length} Photos'
                      : '${currentPhotoIndex + 1}/${widget.postImages.length} Photo',
                  style: theme.textTheme.bodySmall!.copyWith(
                      color: greyColor,
                      fontWeight: FontWeight.w200,
                      fontSize: 12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           if (widget.currentReact == Reacts.like)
                    //             widget.currentReact = Reacts.none;
                    //           else
                    //             widget.currentReact = Reacts.like;
                    //         });
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.all(2),
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           border: widget.currentReact == Reacts.like
                    //               ? Border.all(color: blueColor, width: 2)
                    //               : null,
                    //         ),
                    //         child: Icon(
                    //           MyFlutterApp.thumbs_up,
                    //           color: orangeColor,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     Text(
                    //       widget.likes['Like'].toString(),
                    //       style: theme.textTheme.bodySmall!
                    //           .copyWith(color: Colors.black, fontSize: 15),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           if (widget.currentReact == Reacts.dislike)
                    //             widget.currentReact = Reacts.none;
                    //           else
                    //             widget.currentReact = Reacts.dislike;
                    //         });
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.all(2),
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           border: widget.currentReact == Reacts.dislike
                    //               ? Border.all(color: blueColor, width: 2)
                    //               : null,
                    //         ),
                    //         child: Icon(
                    //           MyFlutterApp.thumbs_down,
                    //           color: orangeColor,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     Text(
                    //       widget.likes['Dislike'].toString(),
                    //       style: theme.textTheme.bodySmall!
                    //           .copyWith(color: Colors.black, fontSize: 15),
                    //     )
                    //   ],
                    // ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           if (widget.currentReact == Reacts.clap)
                    //             widget.currentReact = Reacts.none;
                    //           else
                    //             widget.currentReact = Reacts.clap;
                    //         });
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.all(2),
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           border: widget.currentReact == Reacts.clap
                    //               ? Border.all(color: blueColor, width: 2)
                    //               : null,
                    //         ),
                    //         child: Icon(
                    //           MyFlutterApp.clapping_svgrepo_com,
                    //           color: orangeColor,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     Text(
                    //       widget.likes['Clap'].toString(),
                    //       style: theme.textTheme.bodySmall!
                    //           .copyWith(color: Colors.black, fontSize: 15),
                    //     )
                    //   ],
                    // ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           if (widget.currentReact == Reacts.strong)
                    //             widget.currentReact = Reacts.none;
                    //           else
                    //             widget.currentReact = Reacts.strong;
                    //         });
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.all(2),
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           border: widget.currentReact == Reacts.strong
                    //               ? Border.all(color: blueColor, width: 2)
                    //               : null,
                    //         ),
                    //         child: Icon(
                    //           MyFlutterApp.muscle_svgrepo_com__1_,
                    //           color: orangeColor,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     Text(
                    //       widget.likes['Strong'].toString(),
                    //       style: theme.textTheme.bodySmall!
                    //           .copyWith(color: Colors.black, fontSize: 15),
                    //     )
                    //   ],
                    // ),
                    TextButton(
                      onPressed: () {
                        // showBottomSheet(
                        //     context: context,
                        //     builder: (ctx) => BottomSheet(
                        //           shape: const RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.only(
                        //                   topLeft: Radius.circular(15),
                        //                   topRight: Radius.circular(15))),
                        //           onClosing: () {},
                        //           builder: (BuildContext context) => SizedBox(
                        //             width: double.infinity,
                        //             height: mq.size.height * 0.75,
                        //             child: Column(
                        //               children:
                        //                   comments.map((e) => Text(e)).toList(),
                        //             ),
                        //           ),
                        //         ));
                      },
                      child: Row(
                        children: [
                          Text(
                            'Comments'.tr(),
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15,
                            color: orangeColor,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class webpollPostCard extends StatelessWidget {
  webpollPostCard(
      {required this.coachName,
      required this.coachImageUrl,
      required this.title,
      required this.ctx,
      Key? key})
      : super(key: key);

  String coachName;
  String coachImageUrl;
  String title;
  BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);

    return Container(
      width: mq.size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: blueColor, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(coachImageUrl),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coach $coachName',
                    style:
                        theme.textTheme.bodySmall!.copyWith(color: blueColor),
                  ),
                  Text(
                    '6/3/2022 - 5:33 PM',
                    style: theme.textTheme.displaySmall!
                        .copyWith(color: greyColor, fontSize: 10),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style:
                  theme.textTheme.bodyMedium!.copyWith(color: Colors.black54),
            ),
          ),
          // Consumer<MobileHomeViewModel>(
          //   builder: (context, value, child) => RadioListTile<String>(
          //     title: const Text('Agree').tr(),
          //     secondary: value.getRadioValue != ''
          //         ? Text(
          //             '79%',
          //             style: theme.textTheme.bodySmall,
          //           )
          //         : null,
          //     activeColor: orangeColor,
          //     value: 'Agree',
          //     groupValue: value.getRadioValue,
          //     toggleable: true,
          //     onChanged: (String? radioValue) {
          //       value.setRadioValue(radioValue ?? '');
          //     },
          //   ),
          // ),
          // Consumer<MobileHomeViewModel>(
          //   builder: (context, value, child) => RadioListTile<String>(
          //     title: const Text('Disagree').tr(),
          //     secondary: value.getRadioValue != ''
          //         ? Text(
          //             '21%',
          //             style: theme.textTheme.bodySmall,
          //           )
          //         : null,
          //     activeColor: orangeColor,
          //     value: 'Disagree',
          //     groupValue: value.getRadioValue,
          //     toggleable: true,
          //     onChanged: (String? radioValue) {
          //       value.setRadioValue(radioValue ?? '');
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
