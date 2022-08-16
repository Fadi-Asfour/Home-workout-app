import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/app_control_view_model.dart';
import 'package:provider/provider.dart';

class AppControlView extends StatefulWidget {
  const AppControlView({Key? key}) : super(key: key);

  @override
  State<AppControlView> createState() => _AppControlViewState();
}

class _AppControlViewState extends State<AppControlView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<AppControlViewModel>(context, listen: false)
          .setAppFeutures(lang: getLang(context), context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'App Control',
          style: theme.textTheme.bodyMedium,
        ).tr(),
      ),
      body: Consumer<AppControlViewModel>(
        builder: (context, control, child) => control.getIsLoading
            ? Center(
                child: bigLoader(color: orangeColor),
              )
            : RefreshIndicator(
                color: orangeColor,
                onRefresh: () async {
                  await Provider.of<AppControlViewModel>(context, listen: false)
                      .setAppFeutures(lang: getLang(context), context: context);
                },
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    child: Column(
                      children: control.getAppFeutures
                          .map(
                            (e) => control.getIsLoading
                                ? smallLoader(color: orangeColor)
                                : SwitchListTile(
                                    activeColor: Colors.green,
                                    title: Text(e.name),
                                    value: e.isActive == 1 ? true : false,
                                    onChanged: (value) async {
                                      await control.editAppFeuture(
                                          lang: getLang(context),
                                          context: context,
                                          id: e.id);
                                    }),
                          )
                          .toList(),
                    )),
              ),
      ),
    );
  }
}
