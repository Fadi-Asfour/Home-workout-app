// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Posts%20View%20Model/posts_view_model.dart';
import 'package:home_workout_app/views/Home%20View/Mobile/mobile_home_view_widgets.dart';
import 'package:provider/provider.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<PostsViewModel>(context, listen: false).clearPosts();
      Provider.of<PostsViewModel>(context, listen: false).setPage(0);
      Provider.of<PostsViewModel>(context, listen: false).setPosts(
          context.locale == const Locale('en') ? 'en' : 'ar', context);

      _scrollController.addListener(() {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          Provider.of<PostsViewModel>(context, listen: false).setPosts(
              context.locale == const Locale('en') ? 'en' : 'ar', context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      color: orangeColor,
      onRefresh: () async {
        Provider.of<PostsViewModel>(context, listen: false).clearPosts();
        Provider.of<PostsViewModel>(context, listen: false).setPage(0);
        await Provider.of<PostsViewModel>(context, listen: false).setPosts(
            context.locale == const Locale('en') ? 'en' : 'ar', context);
      },
      child: Consumer<PostsViewModel>(
          builder: (context, posts, child) => (posts.getIsLoading &&
                  posts.getPosts.isEmpty)
              ? Center(child: bigLoader(color: orangeColor))
              : (posts.getPosts.isEmpty
                  ? Center(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('There are no posts',
                                style: theme.textTheme.bodySmall!
                                    .copyWith(color: greyColor))
                            .tr(),
                        TextButton(
                            onPressed: () async {
                              Provider.of<PostsViewModel>(context,
                                      listen: false)
                                  .clearPosts();
                              Provider.of<PostsViewModel>(context,
                                      listen: false)
                                  .setPage(0);
                              await Provider.of<PostsViewModel>(context,
                                      listen: false)
                                  .setPosts(
                                      context.locale == const Locale('en')
                                          ? 'en'
                                          : 'ar',
                                      context);
                            },
                            child: Text('Refresh',
                                    style: theme.textTheme.bodySmall)
                                .tr())
                      ],
                    ))
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(
                                parent: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics())),
                            controller: _scrollController,
                            child: Column(
                              children: posts.getPosts.map((e) {
                                if (e.type == 2 || e.type == 3)
                                  return pollPostCard(post: e, ctx: context);
                                else
                                  return NormalPostCard(post: e, ctx: context);
                              }).toList(),
                            ),
                          ),
                        ),
                        if (posts.getMoreIsLoading)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: bigLoader(color: orangeColor),
                          )
                      ],
                    ))),
    );
  }
}
