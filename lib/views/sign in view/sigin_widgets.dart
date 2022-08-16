import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';

class inputTextForm extends StatelessWidget {
  inputTextForm(
      {required this.specialIcon,
      required this.textlabel,
      required this.inputType,
      required this.inputAction,
      required this.secureText,
      Key? key})
      : super(key: key);
  IconData specialIcon;
  String textlabel;
  TextInputType inputType;
  TextInputAction inputAction;
  bool secureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
          color: Colors.white70.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        decoration: InputDecoration(
          // focusedErrorBorder:  OutlineInputBorder(
          //   borderSide:
          //       BorderSide(color: blueColor, width: 1.5),
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(15),
          //   ),
          // ),

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
          labelText: textlabel,
          labelStyle: TextStyle(
              color: orangeColor, fontSize: 15, fontWeight: FontWeight.bold),
          prefixIcon: Icon(
            specialIcon,
            color: blueColor,
            size: 33,
          ),
        ),
        style: TextStyle(
            color: blueColor, fontSize: 15, fontWeight: FontWeight.bold),
        keyboardType: inputType,
        obscureText: secureText,
        textInputAction: inputAction,
      ),
    );
    //  inputTextForm(
    //                       specialIcon: ,
    //                       textlabel: ,
    //                       inputType: ,
    //                       inputAction: ,
    //                       secureText: ,
    //                     ),
  }
}
