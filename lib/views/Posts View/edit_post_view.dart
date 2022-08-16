import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/post_models.dart';
import 'package:home_workout_app/view_models/Posts%20View%20Model/edit_post_view_model.dart';
import 'package:home_workout_app/views/Home%20View/Mobile/mobile_home_view_widgets.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../view_models/Posts View Model/create_post_view_model.dart';
import '../Home View/home_view_widgets.dart';

class EditPostView extends StatefulWidget {
  EditPostView({Key? key}) : super(key: key);

  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  TextEditingController newtextController = TextEditingController();
  TextEditingController choiceController = TextEditingController();

  PostModel post = PostModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      Provider.of<EditPostViewModel>(context, listen: false).resetPick();
      setState(() {
        post = args['post'] ?? PostModel();

        newtextController.text = post.title;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Post',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                maxLines: 15,
                controller: newtextController,
                title: 'Type here...',
              ),
            ),
            if (post.type == 1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        await Provider.of<EditPostViewModel>(context,
                                listen: false)
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
                        await Provider.of<EditPostViewModel>(context,
                                listen: false)
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
                    ),
                  ],
                ),
              ),
            if (post.type == 3)
              Consumer<EditPostViewModel>(
                builder: (context, editpost, child) => TextButton(
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
                                    editpost.addChoice(
                                        choiceController.text.trim(),
                                        context,
                                        post.choices);
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
            if (post.type == 3)
              Consumer<EditPostViewModel>(
                builder: (context, editPost, child) => Column(
                  children: [
                    ListBody(
                      children: editPost.getChoices
                          .map(
                            (e) => Dismissible(
                              onDismissed: (direction) {
                                editPost.removeChoice(e);
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
                                          (editPost.getChoices.indexOf(e) + 1)
                                              .toString(),
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
                    ListBody(
                      children: post.choices
                          .map(
                            (e) => Dismissible(
                              onDismissed: (direction) {
                                setState(() {
                                  post.choices.removeWhere((element) =>
                                      element['vote_id'] == e['vote_id']);
                                });
                                editPost.addToDeletedChoices(e['vote_id']);
                              },
                              key: Key(e['vote_id'].toString()),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: orangeColor,
                                        child: Text(
                                          (post.choices.indexOf(e) +
                                                  editPost.getChoices.length +
                                                  1)
                                              .toString(),
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        e['vote'].toString(),
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
                  ],
                ),
              ),
            if (Provider.of<EditPostViewModel>(context, listen: true)
                    .getPickedImages!
                    .isNotEmpty ||
                post.imagesUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text('Photos:').tr()),
                    ),
                    Column(
                      children: [
                        if (Provider.of<EditPostViewModel>(context,
                                listen: true)
                            .getPickedImages!
                            .isNotEmpty)
                          ListBody(
                            children: Provider.of<EditPostViewModel>(context,
                                    listen: true)
                                .getPickedImages!
                                .map(
                                  (e) => Dismissible(
                                    onDismissed: (_) {
                                      Provider.of<EditPostViewModel>(context,
                                              listen: false)
                                          .removePhoto(e.path);
                                    },
                                    key: Key(e.path),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Builder(
                                        builder: (BuildContext context) {
                                          try {
                                            return Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image(
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      const LoadingContainer(),
                                                  loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) =>
                                                      loadingProgress != null
                                                          ? const LoadingContainer()
                                                          : child,
                                                  //width: mq.size.width * 0.95,
                                                  //height: 250,
                                                  fit: BoxFit.cover,
                                                  image:
                                                      FileImage(File(e.path)),
                                                ),
                                              ),
                                            );
                                          } catch (e) {
                                            return const LoadingContainer();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        if (Provider.of<EditPostViewModel>(context,
                                listen: true)
                            .getPickedImages!
                            .isNotEmpty)
                          Divider(
                            thickness: 1,
                            color: blueColor,
                            endIndent: 50,
                            indent: 50,
                          ),
                        if (post.imagesUrl.isNotEmpty)
                          ListBody(
                            children: post.imagesUrl
                                .map(
                                  (e) => Dismissible(
                                    onDismissed: (_) {
                                      setState(() {
                                        post.imagesUrl.removeWhere((element) =>
                                            element['id'] == e['id']);
                                      });
                                      Provider.of<EditPostViewModel>(context,
                                              listen: false)
                                          .addToDeletedMedia(e['id']);
                                    },
                                    key: Key(e['id'].toString()),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Builder(
                                        builder: (BuildContext context) {
                                          try {
                                            return Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image(
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      const LoadingContainer(),
                                                  loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) =>
                                                      loadingProgress != null
                                                          ? const LoadingContainer()
                                                          : child,
                                                  //width: mq.size.width * 0.95,
                                                  //height: 250,
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(e['url']),
                                                ),
                                              ),
                                            );
                                          } catch (e) {
                                            return const LoadingContainer();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      color: blueColor,
                      endIndent: 50,
                      indent: 50,
                    ),
                  ],
                ),
              ),
            if (Provider.of<EditPostViewModel>(context, listen: true)
                    .getPickedVideo!
                    .isNotEmpty ||
                post.videosUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text('Videos:').tr()),
                    ),
                    Column(
                      children: [
                        if (Provider.of<EditPostViewModel>(context,
                                listen: true)
                            .getPickedVideo!
                            .isNotEmpty)
                          ListBody(
                            children: Provider.of<EditPostViewModel>(context,
                                    listen: true)
                                .getPickedVideo!
                                .map((e) {
                              return Column(
                                children: [
                                  Dismissible(
                                    onDismissed: (_) {
                                      Provider.of<EditPostViewModel>(context,
                                              listen: false)
                                          .removeVideo(e.path);
                                    },
                                    key: Key(e.path),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: blueColor)),
                                          // width: mq.size.width * 0.9,
                                          height: 500,
                                          child: FileVideoCard(
                                            videoPath: e.path,
                                          )),
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
                        ListBody(
                          children: post.videosUrl.map((e) {
                            return Column(
                              children: [
                                Dismissible(
                                  onDismissed: (_) {
                                    setState(() {
                                      post.videosUrl.removeWhere((element) =>
                                          element['id'] == e['id']);
                                    });
                                    Provider.of<EditPostViewModel>(context,
                                            listen: false)
                                        .addToDeletedMedia(e['id']);
                                  },
                                  key: Key(e['id'].toString()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: blueColor)),
                                        // width: mq.size.width * 0.9,
                                        height: 500,
                                        child: VideoCard(
                                          videoUrl: e['url'],
                                        )),
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
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Consumer<EditPostViewModel>(
                builder: (context, editPost, child) => editPost.getIsLoading
                    ? bigLoader(color: orangeColor)
                    : ElevatedButton(
                        onPressed: () async {
                          if (post.type == 1) {
                            await editPost.updateNormalPost(
                                newtitle: newtextController.text.trim(),
                                newimages: editPost.getPickedImages ?? [],
                                newvideos: editPost.getPickedVideo ?? [],
                                postId: post.postId,
                                deletedMedia: editPost.getDeletedMedia,
                                lang: context.locale == const Locale('en')
                                    ? 'en'
                                    : 'ar',
                                context: context);
                          } else {
                            await editPost.updatePollPost(
                              newtitle: newtextController.text.trim(),
                              postId: post.postId,
                              postType: post.type,
                              context: context,
                              lang: context.locale == const Locale('en')
                                  ? 'en'
                                  : 'ar',
                            );
                          }
                        },
                        child: const Text('Edit').tr()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
