import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Dashboards%20View%20Model/dashboards_view_model.dart';
import 'package:home_workout_app/views/Dashboards%20View/dashboards_widget.dart';
import 'package:provider/provider.dart';

class DashboardsView extends StatefulWidget {
  const DashboardsView({Key? key}) : super(key: key);

  @override
  State<DashboardsView> createState() => _DashboardsViewState();
}

class _DashboardsViewState extends State<DashboardsView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<DashboardsViewModel>(context, listen: false)
          .setDashbaord(lang: getLang(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboards',
          style: theme.textTheme.bodyMedium,
        ).tr(),
      ),
      body: Consumer<DashboardsViewModel>(
        builder: (context, dashbaords, child) => RefreshIndicator(
          color: orangeColor,
          onRefresh: () async {
            await Provider.of<DashboardsViewModel>(context, listen: false)
                .setDashbaord(lang: getLang(context));
          },
          child: dashbaords.getIsLoading
              ? Center(child: bigLoader(color: orangeColor))
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      DashboardListTileContainer(
                        title: 'Pending posts',
                        subtitle: dashbaords.getDashboard.posts.toString(),
                        onTap: () {
                          Navigator.pushNamed(context, '/postsDashboard');
                        },
                      ),
                      DashboardListTileContainer(
                        title: 'Pending CVs',
                        subtitle: dashbaords.getDashboard.CVs.toString(),
                        onTap: () {
                          Navigator.pushNamed(context, '/cvsDashboard');
                        },
                      ),
                      DashboardListTileContainer(
                        title: 'Reported posts',
                        subtitle:
                            dashbaords.getDashboard.reportedPosts.toString(),
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/reportedPostDashboard');
                        },
                      ),
                      DashboardListTileContainer(
                        title: 'Reported comments',
                        subtitle:
                            dashbaords.getDashboard.reportedComments.toString(),
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/reportedCommentsDashboard');
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
