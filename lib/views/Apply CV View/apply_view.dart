import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../view_models/CV View Model/apply_view_model.dart';

class ApplyView extends StatefulWidget {
  ApplyView({Key? key}) : super(key: key);

  @override
  State<ApplyView> createState() => _ApplyViewState();
}

TextEditingController _textEditingController = TextEditingController();

class _ApplyViewState extends State<ApplyView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<ApplyViewModel>(context, listen: false).resetPick();
      _textEditingController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Apply',
          style: theme.textTheme.bodyMedium!,
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: getLang(context) == 'en'
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Text(
                  'Choose the specialization',
                  style: theme.textTheme.bodySmall!,
                ).tr(),
              ),
            ),
            Consumer<ApplyViewModel>(
              builder: (context, apply, child) => Row(
                children: [
                  Expanded(
                    child: RadioListTile<int>(
                      activeColor: blueColor,
                      title: Text(
                        'Coach',
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: blueColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      value: 1,
                      groupValue: apply.getGroupValue,
                      onChanged: (value) {
                        apply.setGroupValue(value ?? 0);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<int>(
                      activeColor: blueColor,
                      title: Text(
                        'dietitian',
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: blueColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      value: 2,
                      groupValue: apply.getGroupValue,
                      onChanged: (value) {
                        apply.setGroupValue(value ?? 0);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                  maxLines: 10,
                  controller: _textEditingController,
                  title: 'Type something about you here... (Optional)'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () async {
                  await Provider.of<ApplyViewModel>(context, listen: false)
                      .pickCV();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Upload your CV',
                      style: theme.textTheme.bodySmall!,
                    ).tr(),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.file_present_rounded,
                      color: blueColor,
                    )
                  ],
                ),
              ),
            ),
            if (Provider.of<ApplyViewModel>(context, listen: true)
                    .getPickedCV !=
                null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Provider.of<ApplyViewModel>(context, listen: true)
                        .getPickCVIsLoading
                    ? bigLoader(color: orangeColor)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              Provider.of<ApplyViewModel>(context, listen: true)
                                  .getFileData,
                              style: theme.textTheme.bodySmall!.copyWith(
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
                              Navigator.pushNamed(context, '/pdf', arguments: {
                                'file': Provider.of<ApplyViewModel>(context,
                                            listen: false)
                                        .getPickedCV ??
                                    File(''),
                                'type': 'file'
                              });
                            },
                            child: Text(
                              'Open',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: blueColor),
                            ).tr(),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Provider.of<ApplyViewModel>(context,
                                      listen: false)
                                  .pickCV();
                            },
                            child: Text(
                              'Edit',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: blueColor),
                            ).tr(),
                          )
                        ],
                      ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Consumer<ApplyViewModel>(
                builder: (context, apply, child) => apply.getIsLoading
                    ? bigLoader(color: orangeColor)
                    : ElevatedButton(
                        onPressed: () async {
                          if (apply.getPickedCV == null) {
                            showSnackbar(
                                const Text('You have to add your CV'), context);
                            return;
                          } else if (apply.getGroupValue == 0) {
                            showSnackbar(
                                const Text(
                                    'You have to selete the specialization'),
                                context);
                            return;
                          } else {
                            await apply.sendCV(
                                desc: _textEditingController.text.trim(),
                                context: context,
                                lang: getLang(context));
                          }
                        },
                        child: const Text('Apply').tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
