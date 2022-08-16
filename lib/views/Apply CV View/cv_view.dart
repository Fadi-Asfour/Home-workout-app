import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_models/CV View Model/apply_view_model.dart';

class CVView extends StatefulWidget {
  const CVView({Key? key}) : super(key: key);

  @override
  State<CVView> createState() => _CVViewState();
}

class _CVViewState extends State<CVView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<ApplyViewModel>(context, listen: false).resetPick();
      Provider.of<ApplyViewModel>(context, listen: false)
          .setCV(lang: getLang(context));
    });
  }

  String specString = 'Specialization:'.tr();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CV',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: Consumer<ApplyViewModel>(
          builder: (context, cv, child) => cv.getIsLoading
              ? Center(
                  child: bigLoader(color: orangeColor),
                )
              : (cv.getCV.role.isEmpty
                  ? Center(
                      child: Text(
                        "You don't have a CV",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: greyColor),
                      ).tr(),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<ApplyViewModel>(context,
                                listen: false)
                            .setCV(lang: getLang(context));
                      },
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 50),
                              child: Text(
                                '$specString ${cv.getCV.role}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            if (cv.getCV.desc.isNotEmpty)
                              Align(
                                alignment: context.locale == const Locale('en')
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    'Description',
                                    style: theme.textTheme.bodySmall,
                                  ).tr(),
                                ),
                              ),
                            if (cv.getCV.desc.isEmpty)
                              Text(
                                'No Description',
                                style: theme.textTheme.bodySmall!
                                    .copyWith(color: greyColor),
                              ).tr(),
                            if (cv.getCV.desc.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  width: mq.size.width * 0.95,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: blueColor),
                                  ),
                                  child: Text(
                                    cv.getCV.desc,
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            Align(
                              alignment: context.locale == const Locale('en')
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 50, bottom: 5),
                                child: Text(
                                  'CV',
                                  style: theme.textTheme.bodySmall,
                                ).tr(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                bottom: 200,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      cv.getCV.fileUrl,
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              color: greyColor,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 15),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/pdf',
                                          arguments: {
                                            'file': cv.getCV.fileUrl,
                                            'type': 'network'
                                          });
                                    },
                                    child: Text(
                                      'Open',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(color: blueColor),
                                    ).tr(),
                                  )
                                ],
                              ),
                            ),
                            if (cv.getIsDeleteLoading)
                              bigLoader(color: orangeColor)
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (Provider.of<ProfileViewModel>(context,
                                                  listen: true)
                                              .getUserData
                                              .roleId !=
                                          2 &&
                                      Provider.of<ProfileViewModel>(context,
                                                  listen: true)
                                              .getUserData
                                              .roleId !=
                                          3)
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext ctx) =>
                                              AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            content: Text(
                                              'Are you sure to delete the cv ?',
                                              style: theme.textTheme.bodySmall,
                                            ).tr(),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(ctx);
                                                    await cv.deleteCV(
                                                        lang: getLang(context),
                                                        context: context);
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: theme
                                                        .textTheme.bodySmall!
                                                        .copyWith(
                                                            color: Colors.red),
                                                  ).tr()),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(ctx);
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: theme
                                                        .textTheme.bodySmall!
                                                        .copyWith(
                                                            color: blueColor),
                                                  ).tr())
                                            ],
                                          ),
                                        );
                                      },
                                      style: theme.elevatedButtonTheme.style!
                                          .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
                                      child: const Text('Delete').tr(),
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/editCV',
                                          arguments: {'cv': cv.getCV});
                                    },
                                    style: theme.elevatedButtonTheme.style!
                                        .copyWith(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    blueColor)),
                                    child: const Text('Edit').tr(),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ))),
    );
  }
}
