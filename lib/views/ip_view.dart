import 'package:flutter/material.dart';
import 'package:home_workout_app/constants.dart';

class IPView extends StatefulWidget {
  IPView({Key? key}) : super(key: key);

  @override
  State<IPView> createState() => _IPViewState();
}

class _IPViewState extends State<IPView> {
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController.text = base_URL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setIP(textEditingController.text.trim());
          Navigator.pushNamed(context, '/splash');
        },
        child: const Text('>'),
      ),
      body: Center(
        child: TextField(
          controller: textEditingController,
        ),
      ),
    );
  }
}
