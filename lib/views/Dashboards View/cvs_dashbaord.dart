import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Dashboards%20View%20Model/dashboards_view_model.dart';
import 'package:home_workout_app/views/Dashboards%20View/dashboards_widget.dart';
import 'package:provider/provider.dart';

class CVsDashboard extends StatefulWidget {
  const CVsDashboard({Key? key}) : super(key: key);

  @override
  State<CVsDashboard> createState() => _CVsDashboardState();
}

class _CVsDashboardState extends State<CVsDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<DashboardsViewModel>(context, listen: false).reset();
      Provider.of<DashboardsViewModel>(context, listen: false)
          .setCVs(lang: getLang(context));

      _scrollController.addListener(() {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          Provider.of<DashboardsViewModel>(context, listen: false)
              .setCVs(lang: getLang(context));
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
          'Pending CVs',
          style: theme.textTheme.bodyMedium,
        ).tr(),
      ),
      body: Consumer<DashboardsViewModel>(
        builder: (context, dashbaords, child) => RefreshIndicator(
            color: orangeColor,
            onRefresh: () async {
              Provider.of<DashboardsViewModel>(context, listen: false).reset();
              await Provider.of<DashboardsViewModel>(context, listen: false)
                  .setCVs(lang: getLang(context));
            },
            child: dashbaords.getIsLoading && dashbaords.getCVsDashbaord.isEmpty
                ? Center(child: bigLoader(color: orangeColor))
                : (dashbaords.getCVsDashbaord.isEmpty
                    ? Center(
                        child: Text('There are no pending Cvs',
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
                              children: dashbaords.getCVsDashbaord
                                  .map(
                                    (e) => Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: blueColor,
                                                  width: 1.5)),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      '/anotherUserProfile',
                                                      arguments: {
                                                        'id': e.ownerId
                                                      });
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    e.img),
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              e.userName,
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
                                                    Text(
                                                      e.country,
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color: greyColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'Applied to be a ${e.role}',
                                                style:
                                                    theme.textTheme.bodySmall!,
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                        context, '/pdf',
                                                        arguments: {
                                                          'file': e.fileUrl,
                                                          'type': 'network'
                                                        });
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .file_present_rounded,
                                                        color: greyColor,
                                                        size: 20,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text('Review  the CV',
                                                          style: theme.textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  color:
                                                                      blueColor)),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                        ARRowForCV(id: e.id.toString()),
                                        Divider(
                                          endIndent: 50,
                                          indent: 50,
                                          color: blueColor,
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                            if (dashbaords.getIsLoading &&
                                dashbaords.getCVsDashbaord.isNotEmpty)
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
