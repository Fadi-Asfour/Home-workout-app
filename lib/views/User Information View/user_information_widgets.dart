import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GenderContainer extends StatelessWidget {
  GenderContainer({required this.color, required this.imagePath, Key? key})
      : super(key: key);

  Color color;
  String imagePath;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: mq.size.width > 350 ? mq.size.width * 0.2 : 400,
      height: mq.size.height * 0.25,
      padding: const EdgeInsets.only(bottom: 5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), color: color),
      child: Image(
        image: AssetImage(imagePath),
      ),
    );
  }
}

class UserInfoCustomText extends StatelessWidget {
  UserInfoCustomText(
      {required this.text,
      required this.color,
      this.fontsize = 20,
      this.padding = true,
      Key? key})
      : super(key: key);
  String text;
  Color color;
  double fontsize;
  bool padding;
  @override
  Widget build(BuildContext context) {
    print(context.locale);
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    return Padding(
      padding: padding
          ? EdgeInsets.only(
              left: context.locale == const Locale('en') ? 10 : 0,
              bottom: 25,
              top: 25,
              right: context.locale == const Locale('en') ? 0 : 10)
          : EdgeInsets.all(0),
      child: Align(
        alignment: context.locale == const Locale('en')
            ? Alignment.topLeft
            : Alignment.topRight,
        child: FittedBox(
          child: Text(
            text.tr(),
            style: theme.textTheme.bodyMedium!
                .copyWith(color: color, fontSize: fontsize),
          ).tr(),
        ),
      ),
    );
  }
}
