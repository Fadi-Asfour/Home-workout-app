// ignore_for_file: curly_braces_in_flow_control_structures, avoid_single_cascade_in_expression_statements

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Posts%20View%20Model/create_post_view_model.dart';
import 'package:home_workout_app/views/Home%20View/Mobile/mobile_home_view_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class TypeContainer extends StatelessWidget {
  TypeContainer(
      {required this.title,
      required this.backgroundColor,
      required this.textColor,
      Key? key})
      : super(key: key);
  Color backgroundColor;
  Color textColor;
  String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: blueColor, width: 1),
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: Center(
            child: Text(
              title,
              style: theme.textTheme.bodySmall!
                  .copyWith(color: textColor, fontSize: 12),
            ).tr(),
          ),
        ),
      ),
    );
  }
}

class CreateNormalPostSpace extends StatefulWidget {
  CreateNormalPostSpace({Key? key}) : super(key: key);
  @override
  State<CreateNormalPostSpace> createState() => _CreateNormalPostSpaceState();
}

class _CreateNormalPostSpaceState extends State<CreateNormalPostSpace> {
  //List<VideoPlayerController> _videos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<CreatePostViewModel>(context, listen: false).resetPicked();
    });
  }

  TextEditingController normaltitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            maxLines: 15,
            controller: normaltitleController,
            title: 'Type here...',
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () async {
                await Provider.of<CreatePostViewModel>(context, listen: false)
                    .pickImages();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: blueColor,
                  ),
                  Text(
                    '+ Add photos',
                    style: theme.textTheme.bodySmall,
                  ).tr()
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                await Provider.of<CreatePostViewModel>(context, listen: false)
                    .pickVideos();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.video_camera_back_outlined,
                    color: blueColor,
                  ),
                  Text(
                    '+ Add videos',
                    style: theme.textTheme.bodySmall,
                  ).tr()
                ],
              ),
            )
          ],
        ),
        if (Provider.of<CreatePostViewModel>(context, listen: true)
            .getPickedImages!
            .isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: context.locale == const Locale('en')
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: const Text('Photos:').tr()),
                ),
                ListBody(
                  children:
                      Provider.of<CreatePostViewModel>(context, listen: true)
                          .getPickedImages!
                          .map(
                            (e) => Dismissible(
                              onDismissed: (_) {
                                Provider.of<CreatePostViewModel>(context,
                                        listen: false)
                                    .removePhoto(e.path);
                              },
                              key: Key(e.path),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: FileImage(
                                    File(e.path),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
                Divider(
                  thickness: 1,
                  color: blueColor,
                  endIndent: 50,
                  indent: 50,
                )
              ],
            ),
          ),
        if (Provider.of<CreatePostViewModel>(context, listen: true)
            .getPickedVideo!
            .isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: context.locale == const Locale('en')
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: const Text('Videos:').tr()),
                ),
                ListBody(
                  children:
                      Provider.of<CreatePostViewModel>(context, listen: true)
                          .getPickedVideo!
                          .map((e) {
                    return Column(
                      children: [
                        Dismissible(
                          onDismissed: (_) {
                            Provider.of<CreatePostViewModel>(context,
                                    listen: false)
                                .removeVideo(e.path);
                          },
                          key: Key(e.path),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: blueColor)),
                              width: mq.size.width * 0.9,
                              child: FileVideoCard(videoPath: e.path),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: blueColor,
                          endIndent: 50,
                          indent: 50,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        Consumer<CreatePostViewModel>(
            builder: (context, post, child) => CustomPostButtonn(
                  toDo: () async {
                    await post.postNormal(normaltitleController.text.trim(),
                        context, context.locale == Locale('en') ? 'en' : 'ar');
                  },
                  createPostViewModel: post,
                )),
      ],
    );
  }
}

class CreateNormalPollSpace extends StatefulWidget {
  CreateNormalPollSpace({Key? key}) : super(key: key);

  @override
  State<CreateNormalPollSpace> createState() => _CreateNormalPollSpaceState();
}

class _CreateNormalPollSpaceState extends State<CreateNormalPollSpace> {
  TextEditingController polltitleController = TextEditingController();

  TextEditingController choiceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              maxLines: 15,
              controller: polltitleController,
              title: 'Type here...',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer<CreatePostViewModel>(
            builder: (context, post, child) => TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    content: Container(
                      height: 125,
                      child: Column(
                        children: [
                          CustomTextField(
                              maxLines: 2,
                              controller: choiceController,
                              title: 'Enter the vote'),
                          TextButton(
                              onPressed: () {
                                post.addChoice(
                                    choiceController.text.trim(), context);
                                Navigator.pop(ctx);
                                choiceController.clear();
                              },
                              child: const Text('Add').tr())
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                'Add a vote +',
                style: theme.textTheme.bodySmall,
              ).tr(),
            ),
          ),
          Consumer<CreatePostViewModel>(
            builder: (context, post, child) => ListBody(
              children: post.getChoices
                  .map(
                    (e) => Dismissible(
                      onDismissed: (direction) {
                        post.removeChoice(e);
                      },
                      key: Key(e),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: orangeColor,
                                child: Text(
                                  (post.getChoices.indexOf(e) + 1).toString(),
                                  style: theme.textTheme.bodySmall!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                e,
                                style: theme.textTheme.bodySmall!
                                    .copyWith(color: blueColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Consumer<CreatePostViewModel>(
            builder: (context, post, child) => CustomPostButtonn(
              createPostViewModel: post,
              toDo: () async {
                String lang =
                    context.locale == const Locale('en') ? 'en' : 'ar';
                await post.postPoll(
                    title: polltitleController.text.trim(),
                    lang: lang,
                    context: context,
                    type: 3);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CreateTipPollSpace extends StatelessWidget {
  CreateTipPollSpace({Key? key}) : super(key: key);

  TextEditingController tipPollController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              maxLines: 15,
              controller: tipPollController,
              title: 'Type here...',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Note: This type of poll have only two choices : Agree and disagree',
                  style: theme.textTheme.bodySmall!.copyWith(color: greyColor),
                  textAlign: TextAlign.center,
                ).tr(),
              ),
            ),
          ),
          Consumer<CreatePostViewModel>(
            builder: (context, post, child) => CustomPostButtonn(
              createPostViewModel: post,
              toDo: () async {
                String lang =
                    context.locale == const Locale('en') ? 'en' : 'ar';
                await post.postPoll(
                    title: tipPollController.text.trim(),
                    lang: lang,
                    context: context,
                    type: 2);
              },
            ),
          )
        ],
      ),
    );
  }
}

class CustomPostButtonn extends StatelessWidget {
  CustomPostButtonn(
      {required this.createPostViewModel, required this.toDo, Key? key})
      : super(key: key);

  Function toDo;
  CreatePostViewModel createPostViewModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      child: createPostViewModel.getIsLoading
          ? bigLoader(color: orangeColor)
          : ElevatedButton(
              onPressed: () async {
                await toDo();
              },
              child: const Text('Post').tr(),
            ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField({
    required this.maxLines,
    required this.controller,
    required this.title,
    Key? key,
  }) : super(key: key);
  TextEditingController controller;
  String title;
  int maxLines;
  Function onChange = () {};
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: FittedBox(child: Text(title).tr()),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        floatingLabelStyle: theme.textTheme.bodySmall,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: orangeColor, width: 1.5),
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
          borderSide: BorderSide(color: orangeColor, width: 1.5),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }
}
