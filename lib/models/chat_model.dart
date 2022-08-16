import '../constants.dart';
import 'message_model.dart';

class ChatModel {
  int userId = 0;
  String userName = '';
  String userImg = '';
  int roleId = 0;
  String role = '';
  String last_message = '';
  String last_date = '';

  int id = 0;
  List<MessageModel> messages = [];

  int from = 0;
  int to = 0;

  ChatModel();

  ChatModel.fromJson(Map json) {
    id = json['chat_id'] ?? 0;
    userName = json['user']['name'] ?? '';
    userId = json['user']['id'] ?? 0;
    userImg = json['user']['img'] ?? '';
    if (userImg.substring(0, 4) != 'http') userImg = '$ip/$userImg';
    roleId = json['user']['role_id'] ?? 0;
    role = json['user']['role'] ?? '';

    final data = json['msgs'] as List;

    data.forEach((element) {
      messages.add(MessageModel.fromjson(element));
    });
  }

  ChatModel.fromJsonForList(Map json) {
    userName = json['user']['name'] ?? '';
    userId = json['user']['id'] ?? 0;
    userImg = json['user']['img'] ?? '';
    if (userImg.substring(0, 4) != 'http') userImg = '$ip/$userImg';
    roleId = json['user']['role_id'] ?? 0;
    role = json['user']['role'] ?? '';

    id = json['chat']['id'] ?? 0;
    from = json['chat']['from'] ?? 0;
    to = json['chat']['to'] ?? 0;
    last_message = json['chat']['last_msg'] ?? '';
    last_date = json['chat']['last_date'] ?? '';
  }
}
