// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/view_models/Dashboards%20View%20Model/dashboards_view_model.dart';
import 'package:home_workout_app/views/Dashboards%20View/dashboards_widget.dart';
import 'package:home_workout_app/views/Home%20View/Mobile/mobile_home_view_widgets.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class PostsDashbaordView extends StatefulWidget {
  const PostsDashbaordView({Key? key}) : super(key: key);

  @override
  State<PostsDashbaordView> createState() => _PostsDashbaordViewState();
}

class _PostsDashbaordViewState extends State<PostsDashbaordView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<DashboardsViewModel>(context, listen: false).reset();
      Provider.of<DashboardsViewModel>(context, listen: false)
          .setPostsDashbaord(lang: getLang(context));
      _scrollController.addListener(() {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          Provider.of<DashboardsViewModel>(context, listen: false)
              .setPostsDashbaord(lang: getLang(context));
        }
      });
    });
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending posts',
          style: theme.textTheme.bodyMedium,
        ).tr(),
      ),
      body: Consumer<DashboardsViewModel>(
        builder: (context, dashbaords, child) => RefreshIndicator(
            color: orangeColor,
            onRefresh: () async {
              Provider.of<DashboardsViewModel>(context, listen: false).reset();

              await Provider.of<DashboardsViewModel>(context, listen: false)
                  .setPostsDashbaord(lang: getLang(context));
            },
            child: dashbaords.getIsLoading && dashbaords.getPendingPosts.isEmpty
                ? Center(child: bigLoader(color: orangeColor))
                : (dashbaords.getPendingPosts.isEmpty
                    ? Center(
                        child: Text('There are no pending posts',
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(color: greyColor))
                            .tr())
                    : SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        child: Column(
                          children: [
                            Column(
                                children: dashbaords.getPendingPosts.map((e) {
                              if (e.type == 1)
                                return Column(
                                  children: [
                                    NormalPostCard(post: e, ctx: context),
                                    ARRow(
                                      id: e.postId.toString(),
                                      acceptTitle: 'Accept',
                                      refuseTitle: 'Refuse',
                                      reported: false,
                                    ),
                                    Divider(
                                      color: blueColor,
                                      endIndent: 50,
                                      indent: 50,
                                    ),
                                  ],
                                );
                              else
                                return Column(
                                  children: [
                                    pollPostCard(post: e, ctx: context),
                                    ARRow(
                                      id: e.postId.toString(),
                                      acceptTitle: 'Accept',
                                      refuseTitle: 'Refuse',
                                      reported: false,
                                    ),
                                    Divider(
                                      color: blueColor,
                                      endIndent: 50,
                                      indent: 50,
                                    ),
                                  ],
                                );
                            }).toList()),
                            if (dashbaords.getIsLoading &&
                                dashbaords.getPendingPosts.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: bigLoader(color: orangeColor),
                              )
                          ],
                        ),
                      ))),
      ),
    );
  }
}
