import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../view_models/edit_profile_view_model.dart';

class ChangeEmailView extends StatelessWidget {
  ChangeEmailView({Key? key}) : super(key: key);

  TextEditingController newEmailController = TextEditingController();
  TextEditingController oldEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _emailKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<EditProfileViewModel>(
              builder: (context, value, child) => Form(
                key: _emailKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      child: TextFormField(
                        controller: oldEmailController,
                        validator: (value) {},
                        onSaved: (val) {},
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: FittedBox(child: const Text('Old email').tr()),
                          floatingLabelStyle: theme.textTheme.bodySmall,
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: orangeColor, width: 1.5),
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
                            borderSide:
                                BorderSide(color: orangeColor, width: 1.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      child: TextFormField(
                        controller: newEmailController,
                        validator: (value) {},
                        onSaved: (val) {},
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: FittedBox(child: const Text('New email').tr()),
                          floatingLabelStyle: theme.textTheme.bodySmall,
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: orangeColor, width: 1.5),
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
                            borderSide:
                                BorderSide(color: orangeColor, width: 1.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {},
                        obscureText: value.getemailPasswordObsecure,
                        onSaved: (val) {},
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(value.getemailPasswordObsecure
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded),
                            onPressed: () {
                              value.setemailPasswordObsecure();
                            },
                          ),
                          label: FittedBox(child: const Text('Password').tr()),
                          floatingLabelStyle: theme.textTheme.bodySmall,
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: orangeColor, width: 1.5),
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
                            borderSide:
                                BorderSide(color: orangeColor, width: 1.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Consumer<EditProfileViewModel>(
              builder: (context, value, child) => value.getIsChangeLoading
                  ? bigLoader(color: orangeColor)
                  : ElevatedButton(
                      onPressed: () async {
                        await Provider.of<EditProfileViewModel>(context,
                                listen: false)
                            .changeEmail(
                                oldEmailController.text.trim(),
                                newEmailController.text.trim(),
                                passwordController.text.trim(),
                                context);
                      },
                      child: const Text('Save changes').tr()),
            )
          ],
        ),
      ),
    );
  }
}
