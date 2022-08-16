import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../view_models/edit_profile_view_model.dart';

class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({Key? key}) : super(key: key);

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> _passKey = GlobalKey();
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
                key: _passKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      child: TextFormField(
                        obscureText: value.getPasswordObsecure1,
                        controller: oldPasswordController,
                        validator: (value) {},
                        onSaved: (val) {},
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(value.getPasswordObsecure1
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded),
                            onPressed: () {
                              value.setPasswordObsecure1();
                            },
                          ),
                          label:
                              FittedBox(child: const Text('Old password').tr()),
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
                        obscureText: value.getPasswordObsecure2,
                        controller: newPasswordController,
                        validator: (value) {},
                        onSaved: (val) {},
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(value.getPasswordObsecure2
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded),
                            onPressed: () {
                              value.setPasswordObsecure2();
                            },
                          ),
                          label:
                              FittedBox(child: const Text('New password').tr()),
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
                        obscureText: value.getPasswordObsecure3,
                        controller: confirmPasswordController,
                        validator: (value) {},
                        onSaved: (val) {},
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(value.getPasswordObsecure3
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded),
                            onPressed: () {
                              value.setPasswordObsecure3();
                            },
                          ),
                          label: FittedBox(
                              child: const Text('Confirm new password').tr()),
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
                builder: (context, value, child) =>
                    value.getIsChangePasswordLoading
                        ? bigLoader(color: orangeColor)
                        : ElevatedButton(
                            onPressed: () async {
                              await Provider.of<EditProfileViewModel>(context,
                                      listen: false)
                                  .changePassword(
                                      oldPasswordController.text.trim(),
                                      newPasswordController.text.trim(),
                                      confirmPasswordController.text.trim(),
                                      context);
                            },
                            child: const Text('Save changes').tr()))
          ],
        ),
      ),
    );
  }
}
