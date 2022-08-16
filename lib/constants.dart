// ignore_for_file: constant_identifier_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/my_flutter_app_icons.dart';

Color orangeColor = const Color(0xFFFB8500);
Color blueColor = const Color(0xff126782);
Color greyColor = Colors.grey;

String base_URL = 'http://192.168.137.1:8000/api';

String ip = base_URL.replaceAll('/api', '');

void setIP(String newIp) {
  base_URL = newIp;
  print(newIp);
  print(base_URL);
}

const String apiKey =
    'THSzx8cmJny4DFmjvjX2calOKSduaJxb3YKC9sCuoCdEiF4J9w6qul5kRFwt1mUR';
// const String url = 'http://localhost:8000/api';

Map<String, dynamic> headers = {'accept': 'application/json'};

// String token = 'Bearer ' +
//     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiMDkzNDBiOWQzY2QxOGNlMjhiMjEyNmM0ODFiNTRjMTQ5NDJjYjNhNzViNjI0ZGE2MTE1ZDQ1NTYzNDJjMTM3MzQ5YmQ3YjEyZWRjOGZhZDIiLCJpYXQiOjE2NTc1NjQxNjIuMDI3MjUzLCJuYmYiOjE2NTc1NjQxNjIuMDI3MjYxLCJleHAiOjE2NTgxNjg5NjIuMDEyNzczLCJzdWIiOiI2Iiwic2NvcGVzIjpbIioiXX0.iC0B-cgBuK1J4nJVBm6-3c9ySjvT-1w_06kGjNHV2ht7ZFBSCLcGlkMfCMVOXXgTOLGZwEh2AxLTrbJSjDjMcJOkqtAXXito4_zr240tSzq2hrCKO4-zHHTtHMC4gXCntnls-PdunhyxYQTGiT_KIvyJMjqpaqs0jE9dt-9l8N6QYEv91dyycMxCYq1pNsvi-ABLztzclsM_bRLpSXyN4g1mT0VTnpzhKBqfGmQYvD8V7ciKalbi6DY2RARoDiyJQLh3yPgg1kB9E1x06sbwE3yXLowHkA9-8yT8FUU_T1sOQ0eDNb3RR0JBEKvpS71NMMu7WIXVz1vWyRJ6ywj3iu0kLV_47qYqd9YFG98IUPT5MiZhCoHXheuIGuk2uanoc6y9BiIC839OYPCoc5IqGLbS1XhbDm6C69MCAuvk6MYm9Etp60tfePvy6dysB9LlHjVK3b038nqg1K2P2T8GCT6sDHjmcMjxYuNHyCpsquc1vrc64Khvu6Vi1b9tN_X7929ekKB79pRFlfnhPV5FoJoL9y7d_ZIo0kQ94GrWQcFVXoe_ne0wwWIcmqB9Mfp2qsbkX-uemCIHXrJfBGDgRNehlxJ9puCCmuA91HgsOc_ncHnB86mpVmSwIYMZavIP_eS5w10Lny6nmXQwGOyV2csZ_SeXJt6G_n41rJdmwmA';

enum Gender { male, female }

enum Units { kg, lb, cm, ft }

enum Filters { users, posts, diet, workout, challenges }

// enum Reacts { like, dislike, clap, strong, none }
const reacts = [
  {
    'id': 'type1',
    'name': 'like',
    'icon': Icons.thumb_up_alt_outlined,
  },
  {
    'id': 'type2',
    'name': 'unlike',
    'icon': Icons.thumb_down_alt_outlined,
  },
  {
    'id': 'type3',
    'name': 'clap',
    'icon': MyFlutterApp.clapping_svgrepo_com,
  },
  {
    'id': 'type4',
    'name': 'strong',
    'icon': MyFlutterApp.muscle_svgrepo_com__1_
  },
];

enum PostTypes {
  Normal,
  NormalPoll,
  TipPoll,
}

class CustomLoading extends StatelessWidget {
  const CustomLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: orangeColor,
        strokeWidth: 3,
      ),
    );
  }
}

String getTimezone() {
  print('Timezone: ${DateTime.now().timeZoneOffset.inMinutes}');
  return DateTime.now().timeZoneOffset.inMinutes.toString();
}

String firebaseNotificationToken = '';
getFirebaseNotificationToken() {
  try {
    if (firebaseNotificationToken != '' && firebaseNotificationToken != null) {
      print('firbase token: $firebaseNotificationToken');
      return firebaseNotificationToken;
    } else {
      FirebaseMessaging.instance.getToken().then((value) {
        firebaseNotificationToken = value.toString();
        print('firbase token: $firebaseNotificationToken');
      });
      return firebaseNotificationToken;
    }
  } catch (e) {
    print('get firebase token error: $e');
  }
}
 

//temporary

