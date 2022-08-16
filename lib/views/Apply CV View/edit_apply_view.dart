import 'package:flutter/material.dart';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/models/cv_model.dart';
import 'package:home_workout_app/view_models/CV%20View%20Model/edit_apply_view_model.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';

import '../../view_models/CV View Model/apply_view_model.dart';

class EditApplyView extends StatefulWidget {
  const EditApplyView({Key? key}) : super(key: key);

  @override
  State<EditApplyView> createState() => _EditApplyViewState();
}

class _EditApplyViewState extends State<EditApplyView> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<EditApplyViewModel>(context, listen: false).resetPick();
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      cv = args['cv'] ?? CVModel();
      Provider.of<EditApplyViewModel>(context, listen: false)
          .setFileData(cv.fileUrl);
      Provider.of<EditApplyViewModel>(context, listen: false)
          .setGroupValue(cv.roleId == 2 ? 1 : 2);
      _textEditingController.text = cv.desc;
    });
  }

  CVModel cv = CVModel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Apply',
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
            Consumer<EditApplyViewModel>(
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
              child: Provider.of<EditApplyViewModel>(context, listen: true)
                      .getPickCVIsLoading
                  ? bigLoader(color: orangeColor)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            Provider.of<EditApplyViewModel>(context,
                                    listen: true)
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
                              'file': Provider.of<EditApplyViewModel>(context,
                                          listen: false)
                                      .getPickedCV ??
                                  cv.fileUrl,
                              'type': Provider.of<EditApplyViewModel>(context,
                                              listen: false)
                                          .getPickedCV ==
                                      null
                                  ? 'network'
                                  : 'file'
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
                            await Provider.of<EditApplyViewModel>(context,
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
              child: Consumer<EditApplyViewModel>(
                builder: (context, apply, child) => apply.getIsLoading
                    ? bigLoader(color: orangeColor)
                    : ElevatedButton(
                        onPressed: () async {
                          if (apply.getGroupValue == 0) {
                            showSnackbar(
                                const Text(
                                        'You have to selete the specialization')
                                    .tr()
                                    .tr(),
                                context);
                            return;
                          } else {
                            await apply.sendCV(
                                desc: _textEditingController.text.trim(),
                                context: context,
                                lang: getLang(context));
                          }
                        },
                        child: const Text('Edit Apply').tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
