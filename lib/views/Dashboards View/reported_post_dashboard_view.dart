// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Dashboards%20View%20Model/dashboards_view_model.dart';
import 'package:home_workout_app/views/Dashboards%20View/dashboards_widget.dart';
import 'package:provider/provider.dart';

import '../Home View/Mobile/mobile_home_view_widgets.dart';

class ReportedPostsDashbaordView extends StatefulWidget {
  const ReportedPostsDashbaordView({Key? key}) : super(key: key);

  @override
  State<ReportedPostsDashbaordView> createState() =>
      _ReportedPostsDashbaordViewState();
}

class _ReportedPostsDashbaordViewState
    extends State<ReportedPostsDashbaordView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<DashboardsViewModel>(context, listen: false).reset();
      Provider.of<DashboardsViewModel>(context, listen: false)
          .setReportedPostsDashbaord(lang: getLang(context));
      _scrollController.addListener(() {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          Provider.of<DashboardsViewModel>(context, listen: false)
              .setReportedPostsDashbaord(lang: getLang(context));
        }
      });
    });
  }

  ScrollController _scrollController = ScrollController();
  String reportString = 'Reports count:'.tr();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reported posts',
          style: theme.textTheme.bodyMedium,
        ).tr(),
      ),
      body: Consumer<DashboardsViewModel>(
        builder: (context, dashbaords, child) => RefreshIndicator(
            color: orangeColor,
            onRefresh: () async {
              Provider.of<DashboardsViewModel>(context, listen: false).reset();

              await Provider.of<DashboardsViewModel>(context, listen: false)
                  .setReportedPostsDashbaord(lang: getLang(context));
            },
            child: dashbaords.getIsLoading &&
                    dashbaords.getReportedPosts.isEmpty
                ? Center(child: bigLoader(color: orangeColor))
                : (dashbaords.getReportedPosts.isEmpty
                    ? Center(
                        child: Text('There are no reported posts',
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
                              children: dashbaords.getReportedPosts.map((e) {
                                e.dash = false;
                                if (e.type == 1)
                                  return Column(
                                    children: [
                                      NormalPostCard(post: e, ctx: context),
                                      Text('$reportString ${e.reportsCount}',
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(color: Colors.red)),
                                      ARRow(
                                        id: e.postId.toString(),
                                        acceptTitle: 'Delete reports',
                                        refuseTitle: 'Delete post',
                                        reported: true,
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
                                      Text('$reportString ${e.reportsCount}',
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(color: Colors.red)),
                                      ARRow(
                                        id: e.postId.toString(),
                                        acceptTitle: 'Delete reports',
                                        refuseTitle: 'Delete post',
                                        reported: true,
                                      ),
                                      Divider(
                                        color: blueColor,
                                        endIndent: 50,
                                        indent: 50,
                                      ),
                                    ],
                                  );
                              }).toList(),
                            ),
                            if (dashbaords.getIsLoading &&
                                dashbaords.getReportedPosts.isNotEmpty)
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
