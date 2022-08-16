import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/settings_view_mode.dart';
import 'package:home_workout_app/views/Home%20View/Mobile/mobile_home_view_widgets.dart';
import 'package:provider/provider.dart';

import '../../models/post_models.dart';
import '../../view_models/Posts View Model/posts_view_model.dart';
import '../Home View/home_view_widgets.dart';

class PostView extends StatefulWidget {
  PostView({Key? key}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  PageController page1Controller = PageController();

  PageController page2Controller = PageController();

  int page1index = 0;
  int page2Index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page1Controller.addListener(() {
      setState(() {
        page1index = page1Controller.page!.toInt();
      });
    });
    page2Controller.addListener(() {
      setState(() {
        page2Index = page2Controller.page!.toInt();
      });
    });
  }

  bool openContainer = false;

  String commentText = 'Comments'.tr();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    PostModel post = args['post'];
    String commentsString = 'Comments'.tr();

    return Scaffold(
      bottomNavigationBar: !post.dash
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (post.on_hold == false)
                    InkWell(
                      onTap: () {
                        if (openContainer)
                          setState(() {
                            openContainer = false;
                          });
                      },
                      onLongPress: () {
                        setState(() {
                          openContainer = !openContainer;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: openContainer ? 250 : 75,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: greyColor, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  openContainer = false;
                                });
                                final response =
                                    await Provider.of<PostsViewModel>(context,
                                            listen: false)
                                        .likePost(
                                            lang: context.locale == Locale('en')
                                                ? 'en'
                                                : 'ar',
                                            postId: post.postId,
                                            context: context,
                                            likeId: post.myLike == -1
                                                ? 1
                                                : post.myLike);
                                if (response['success']) {
                                  print(post.myLike);
                                  setState(() {
                                    post.reacts = response['data'];
                                    post.myLike = post.myLike == -1 ? 1 : -1;
                                  });
                                  print(post.myLike);
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    post.myLike == -1
                                        ? reacts[0]['icon'] as IconData
                                        : reacts.firstWhere((element) =>
                                                element['id'] ==
                                                'type${post.myLike}')['icon']
                                            as IconData,
                                    color: post.myLike == -1
                                        ? greyColor
                                        : orangeColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    post.myLike == -1
                                        ? post.reacts.entries
                                            .firstWhere((element) =>
                                                element.key == 'type1')
                                            .value
                                            .toString()
                                        : post.reacts.entries
                                            .firstWhere((element) =>
                                                element.key ==
                                                'type${post.myLike}')
                                            .value
                                            .toString(),
                                    style: theme.textTheme.bodySmall!
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            if (openContainer)
                              const SizedBox(
                                width: 20,
                              ),
                            if (openContainer)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: reacts
                                    .where((element) => post.myLike != -1
                                        ? element['id'] != 'type${post.myLike}'
                                        : element['id'] != 'type1')
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          setState(() {
                                            openContainer = !openContainer;
                                          });
                                          final response =
                                              await Provider.of<PostsViewModel>(
                                                      context,
                                                      listen: false)
                                                  .likePost(
                                                      lang: context.locale ==
                                                              const Locale('en')
                                                          ? 'en'
                                                          : 'ar',
                                                      postId: post.postId,
                                                      context: context,
                                                      likeId: int.parse(e['id']
                                                          .toString()
                                                          .replaceAll(
                                                              'type', '')));

                                          if (response['success']) {
                                            setState(() {
                                              post.reacts = response['data'];
                                              if (post.myLike ==
                                                  int.parse(e['id']
                                                      .toString()
                                                      .replaceAll(
                                                          'type', ''))) {
                                                post.myLike = -1;
                                              } else {
                                                post.myLike = int.parse(e['id']
                                                    .toString()
                                                    .replaceAll('type', ''));
                                              }
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                e['icon'] as IconData,
                                                color: greyColor,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                post.reacts.entries
                                                    .firstWhere((element) =>
                                                        element.key ==
                                                        e['id'].toString())
                                                    .value
                                                    .toString(),
                                                style: theme
                                                    .textTheme.bodySmall!
                                                    .copyWith(
                                                        color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                          ],
                        ),
                      ),
                    ),
                  if (post.on_hold == false)
                    TextButton(
                        onPressed: () {},
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/comments',
                                arguments: {'id': post.postId});
                          },
                          child: Row(
                            children: [
                              Text(
                                '${post.commentsCount} $commentsString',
                                style: theme.textTheme.bodySmall,
                              ).tr(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: orangeColor,
                              )
                            ],
                          ),
                        ))
                ],
              ),
            )
          : null,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(post.pubImageUrl),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              post.pubName,
              style: theme.textTheme.bodySmall!
                  .copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<SettingsViewModel>(
                  builder: (context, value, child) => Text(
                    post.title,
                    style: theme.textTheme.bodyMedium!.copyWith(
                        color: value.getTheme ? Colors.black54 : greyColor),
                  ),
                ),
              ),
            ),
            if (post.imagesUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: context.locale == const Locale('en')
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text(
                    'Photos:',
                    style: theme.textTheme.bodySmall,
                  ).tr(),
                ),
              ),
            if (post.imagesUrl.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: blueColor, width: 2),
                    ),
                    child: Stack(
                      alignment: context.locale == const Locale('en')
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      children: [
                        PageView(
                            controller: page1Controller,
                            children: post.imagesUrl
                                .map(
                                  (e) => Builder(
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
                                              loadingBuilder: (context, child,
                                                      loadingProgress) =>
                                                  loadingProgress != null
                                                      ? const LoadingContainer()
                                                      : child,
                                              width: mq.size.width * 0.95,
                                              //height: 250,
                                              fit: BoxFit.cover,
                                              image: NetworkImage(e['url']),
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        return LoadingContainer();
                                      }
                                    },
                                  ),
                                )
                                .toList()),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: greyColor.withOpacity(0.5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${page1index + 1}/${post.imagesUrl.length}',
                                style: theme.textTheme.bodySmall!.copyWith(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            if (post.videosUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: context.locale == const Locale('en')
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text(
                    'Videos:',
                    style: theme.textTheme.bodySmall,
                  ).tr(),
                ),
              ),
            if (post.videosUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: blueColor, width: 2),
                  ),
                  child: Stack(
                    alignment: context.locale == Locale('en')
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    children: [
                      PageView(
                          controller: page2Controller,
                          children: post.videosUrl
                              .map(
                                (e) => Builder(
                                  builder: (BuildContext context) {
                                    try {
                                      return Center(
                                          child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: VideoCard(
                                          videoUrl: e['url'],
                                        ),
                                      ));
                                    } catch (e) {
                                      return const LoadingContainer();
                                    }
                                  },
                                ),
                              )
                              .toList()),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: greyColor.withOpacity(0.5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${page2Index + 1}/${post.videosUrl.length}',
                              style: theme.textTheme.bodySmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w200),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
