import 'dart:developer';

class MessageModel {
  String message = '';
  int userId = 0;
  String created_at = '';
  int id = 0;
  int chat_id = 0;

  MessageModel();

  MessageModel.fromjson(Map json) {
    log(json.toString());
    message = json['message'] ?? '';
    userId = json['user_id'] ?? 0;
    id = json['id'] ?? 0;
    created_at = json['created_at'] ?? '';
    chat_id = json['chat_id'] ?? 0;
  }
}
