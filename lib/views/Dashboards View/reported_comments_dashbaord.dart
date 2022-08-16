import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Dashboards%20View%20Model/dashboards_view_model.dart';
import 'package:home_workout_app/views/Dashboards%20View/dashboards_widget.dart';
import 'package:provider/provider.dart';

import '../../view_models/profile_view_model.dart';

class ReportedCommentsDashboard extends StatefulWidget {
  const ReportedCommentsDashboard({Key? key}) : super(key: key);

  @override
  State<ReportedCommentsDashboard> createState() => _CVsDashboardState();
}

class _CVsDashboardState extends State<ReportedCommentsDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<DashboardsViewModel>(context, listen: false).reset();
      Provider.of<DashboardsViewModel>(context, listen: false)
          .setReportedCommentsDashbaord(lang: getLang(context));
      _scrollController.addListener(() {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          Provider.of<DashboardsViewModel>(context, listen: false)
              .setReportedCommentsDashbaord(lang: getLang(context));
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
          'Reported comments',
          style: theme.textTheme.bodyMedium,
        ).tr(),
      ),
      body: Consumer<DashboardsViewModel>(
        builder: (context, dashbaords, child) => RefreshIndicator(
            color: orangeColor,
            onRefresh: () async {
              Provider.of<DashboardsViewModel>(context, listen: false).reset();

              await Provider.of<DashboardsViewModel>(context, listen: false)
                  .setReportedCommentsDashbaord(lang: getLang(context));
            },
            child: dashbaords.getIsLoading &&
                    dashbaords.getReportedComments.isEmpty
                ? Center(child: bigLoader(color: orangeColor))
                : (dashbaords.getReportedComments.isEmpty
                    ? Center(
                        child: Text('There are no reported comments',
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
                              children: dashbaords.getReportedComments
                                  .map(
                                    (e) => Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: blueColor, width: 2),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/anotherUserProfile',
                                                              arguments: {
                                                                'id': e.ownerId
                                                              });
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        e.ownerImageUrl),
                                                              ),
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  e.owner,
                                                                  style: theme
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              blueColor),
                                                                ),
                                                                Text(
                                                                  e.createdAt,
                                                                  style: theme
                                                                      .textTheme
                                                                      .displaySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              greyColor,
                                                                          fontSize:
                                                                              10),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 60),
                                                      child: Text(
                                                        e.comment,
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      '$reportString ${e.reports}',
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.red)),
                                                ],
                                              ),
                                            ),
                                            ARForReportedComments(
                                                id: e.id.toString()),
                                            Divider(
                                              indent: 50,
                                              endIndent: 50,
                                              color: blueColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            if (dashbaords.getIsLoading &&
                                dashbaords.getReportedComments.isNotEmpty)
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
