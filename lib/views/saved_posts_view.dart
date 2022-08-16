// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/view_models/Posts%20View%20Model/saved_posts_view_model.dart';
import 'package:home_workout_app/views/Home%20View/Mobile/mobile_home_view_widgets.dart';
import 'package:provider/provider.dart';

import '../components.dart';
import '../constants.dart';

class SavedPostsView extends StatefulWidget {
  const SavedPostsView({Key? key}) : super(key: key);

  @override
  State<SavedPostsView> createState() => _SavedPostsViewState();
}

class _SavedPostsViewState extends State<SavedPostsView> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<SavedPostsViewModel>(context, listen: false).setPage(0);
      Provider.of<SavedPostsViewModel>(context, listen: false)
          .clearSavedPosts();
      Provider.of<SavedPostsViewModel>(context, listen: false).setSavedPosts(
          lang: context.locale == const Locale('en') ? 'en' : 'ar',
          context: context);
      _scrollController.addListener(() {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          Provider.of<SavedPostsViewModel>(context, listen: false)
              .setSavedPosts(
                  lang: context.locale == const Locale('en') ? 'en' : 'ar',
                  context: context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved posts',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: Consumer<SavedPostsViewModel>(
        builder: (context, savedPosts, child) => (savedPosts.getIsLoading &&
                savedPosts.getSavedPosts.isEmpty)
            ? Center(child: bigLoader(color: orangeColor))
            : (savedPosts.getSavedPosts.isEmpty
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'There are no saved posts',
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: greyColor),
                        ).tr(),
                        TextButton(
                          onPressed: () async {
                            Provider.of<SavedPostsViewModel>(context,
                                    listen: false)
                                .setPage(0);
                            Provider.of<SavedPostsViewModel>(context,
                                    listen: false)
                                .clearSavedPosts();
                            await Provider.of<SavedPostsViewModel>(context,
                                    listen: false)
                                .setSavedPosts(
                                    lang: context.locale == const Locale('en')
                                        ? 'en'
                                        : 'ar',
                                    context: context);
                          },
                          child: Text(
                            'Refresh',
                            style: theme.textTheme.bodySmall!.copyWith(
                                color: orangeColor,
                                fontWeight: FontWeight.w300),
                          ).tr(),
                        )
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: orangeColor,
                    onRefresh: () async {
                      Provider.of<SavedPostsViewModel>(context, listen: false)
                          .setPage(0);
                      Provider.of<SavedPostsViewModel>(context, listen: false)
                          .clearSavedPosts();
                      await Provider.of<SavedPostsViewModel>(context,
                              listen: false)
                          .setSavedPosts(
                              lang: context.locale == const Locale('en')
                                  ? 'en'
                                  : 'ar',
                              context: context);
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            child: Column(
                              children: savedPosts.getSavedPosts.map((e) {
                                if (e.type == 2 || e.type == 3)
                                  return pollPostCard(post: e, ctx: context);
                                else
                                  return NormalPostCard(post: e, ctx: context);
                              }).toList(),
                            ),
                          ),
                        ),
                        if (savedPosts.getIsMoreLoading)
                          bigLoader(color: orangeColor)
                      ],
                    ),
                  )),
      ),
    );
  }
}
