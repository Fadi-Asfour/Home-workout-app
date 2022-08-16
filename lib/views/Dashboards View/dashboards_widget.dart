import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Dashboards%20View%20Model/dashboards_view_model.dart';
import 'package:provider/provider.dart';

class DashboardListTileContainer extends StatelessWidget {
  DashboardListTileContainer(
      {required this.title,
      required this.subtitle,
      required this.onTap,
      Key? key})
      : super(key: key);

  String subtitle;
  String title;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: blueColor, width: 1.5)),
        child: ListTile(
          title: Text(
            title,
            style: theme.textTheme.bodyMedium!.copyWith(fontSize: 17),
          ).tr(),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodySmall!.copyWith(color: greyColor),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: orangeColor,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

class ARRow extends StatefulWidget {
  ARRow(
      {required this.id,
      required this.acceptTitle,
      required this.refuseTitle,
      required this.reported,
      Key? key})
      : super(key: key);

  String id;
  String acceptTitle;
  String refuseTitle;
  bool reported;

  @override
  State<ARRow> createState() => _ARRowState();
}

class _ARRowState extends State<ARRow> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: bigLoader(color: orangeColor),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<DashboardsViewModel>(context,
                            listen: false)
                        .ARPosts(
                            lang: getLang(context),
                            id: widget.id,
                            context: context,
                            acc: true,
                            reported: widget.reported);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text(
                    widget.acceptTitle,
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: Colors.green),
                  ).tr()),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<DashboardsViewModel>(context,
                            listen: false)
                        .ARPosts(
                            lang: getLang(context),
                            id: widget.id,
                            context: context,
                            acc: false,
                            reported: widget.reported);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text(
                    widget.refuseTitle,
                    style:
                        theme.textTheme.bodySmall!.copyWith(color: Colors.red),
                  ).tr()),
            ],
          );
  }
}

class ARRowForCV extends StatefulWidget {
  ARRowForCV({required this.id, Key? key}) : super(key: key);

  String id;

  @override
  State<ARRowForCV> createState() => _ARRowForCVState();
}

class _ARRowForCVState extends State<ARRowForCV> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: bigLoader(color: orangeColor),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<DashboardsViewModel>(context,
                            listen: false)
                        .ARCV(
                            lang: getLang(context),
                            id: widget.id,
                            context: context,
                            state: true);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text(
                    'Accept',
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: Colors.green),
                  ).tr()),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<DashboardsViewModel>(context,
                            listen: false)
                        .ARCV(
                            lang: getLang(context),
                            id: widget.id,
                            context: context,
                            state: false);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text(
                    'Refuse',
                    style:
                        theme.textTheme.bodySmall!.copyWith(color: Colors.red),
                  ).tr()),
            ],
          );
  }
}

class ARForReportedComments extends StatefulWidget {
  ARForReportedComments({required this.id, Key? key}) : super(key: key);

  String id;

  @override
  State<ARForReportedComments> createState() => _ARForReportedCommentsState();
}

class _ARForReportedCommentsState extends State<ARForReportedComments> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: bigLoader(color: orangeColor),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<DashboardsViewModel>(context,
                            listen: false)
                        .ARComments(
                            lang: getLang(context),
                            id: widget.id,
                            acc: false,
                            context: context);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Delete reports',
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: Colors.green),
                      ).tr(),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        '(Keep)',
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: greyColor, fontSize: 12),
                      ).tr(),
                    ],
                  )),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<DashboardsViewModel>(context,
                            listen: false)
                        .ARComments(
                            lang: getLang(context),
                            id: widget.id,
                            acc: true,
                            context: context);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text(
                    'Delete comment',
                    style:
                        theme.textTheme.bodySmall!.copyWith(color: Colors.red),
                  ).tr()),
            ],
          );
  }
}
