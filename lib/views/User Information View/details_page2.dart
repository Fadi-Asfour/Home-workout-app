import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/user_information_view_model.dart';
import 'package:home_workout_app/views/User%20Information%20View/user_information_widgets.dart';
import 'package:provider/provider.dart';

class Details2Page extends StatefulWidget {
  Details2Page({required this.saveFunction, Key? key}) : super(key: key);

  Function saveFunction;

  @override
  State<Details2Page> createState() => _Details2PageState();
}

class _Details2PageState extends State<Details2Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<UserInformationViewModel>(context, listen: false)
          .setDiseases(context.locale == const Locale('en') ? 'en' : 'ar');
    });
  }

  TextEditingController searchController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 90,
        child: ElevatedButton(
          onPressed: () {
            Provider.of<UserInformationViewModel>(context, listen: false)
                .sendHealthRecord(
                    descController.text.trim(),
                    context.locale == const Locale('en') ? 'en' : 'ar',
                    context);
          },
          child: const Text('Save').tr(),
        ),
      ),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight:
              Provider.of<UserInformationViewModel>(context, listen: true)
                      .getAddDesc
                  ? 325
                  : 205,
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: UserInfoCustomText(
                        text: 'Do you suffer any of this diseases ?',
                        padding: false,
                        color: orangeColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text(
                        'Skip',
                        style: theme.textTheme.bodySmall!.copyWith(
                            color: blueColor, fontWeight: FontWeight.w200),
                      ).tr(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UserInfoCustomText(
                  text: 'If you suffer any of this check the box.',
                  fontsize: 12,
                  color: greyColor,
                  padding: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70,
                  child: TextField(
                    onChanged: (value) {
                      Provider.of<UserInformationViewModel>(context,
                              listen: false)
                          .setSearchValue(value);
                    },
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      label: FittedBox(child: const Text('Search').tr()),
                      floatingLabelStyle: theme.textTheme.bodySmall,
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: orangeColor, width: 1.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: greyColor, width: 1.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: orangeColor, width: 1.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Consumer<UserInformationViewModel>(
                builder: (context, consumer, child) => consumer.getAddDesc
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              maxLength: 200,
                              maxLines: 5,
                              controller: descController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                label: FittedBox(
                                    child: const Text('Description').tr()),
                                floatingLabelStyle: theme.textTheme.bodySmall,
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: orangeColor, width: 1.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: greyColor, width: 1.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: orangeColor, width: 1.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              descController.clear();
                              consumer.setAddDesc();
                            },
                            icon: Icon(Icons.close),
                            color: blueColor,
                          )
                        ],
                      )
                    : TextButton(
                        onPressed: () {
                          consumer.setAddDesc();
                        },
                        child: Text(
                          'Add description',
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: blueColor, fontWeight: FontWeight.w200),
                        ).tr()),
              ),
            ],
          )),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<UserInformationViewModel>(
                builder: (context, consumer, child) => Scrollbar(
                  child: Column(
                    children: consumer.getDiseases
                        .where((element) {
                          return element['name']
                              .toString()
                              .toLowerCase()
                              .contains(
                                  consumer.getSearchValue.toLowerCase().trim());
                        })
                        .map(
                          (e) => CheckboxListTile(
                            title: UserInfoCustomText(
                              text: e['name'].toString(),
                              color: blueColor,
                              fontsize: 15,
                            ),
                            value: e['selected'],
                            onChanged: (value) {
                              consumer.changeDiseasesValue(e['id'], value);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
