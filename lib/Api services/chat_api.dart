import 'dart:developer';

import 'package:home_workout_app/models/chat_model.dart';

import '../constants.dart';
import 'dart:convert';

import '../main.dart';
import 'package:http/http.dart' as http;

class ChatAPI {
  Future<ChatModel> getChat({required String lang, required int userId}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/chat/'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone(),
          'id': userId.toString()
        },
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return ChatModel.fromJson(jsonDecode(response.body)['data']);
      } else {
        print(jsonDecode(response.body));
        return ChatModel();
      }
    } catch (e) {
      print('Get Chat Messages Error: $e');
      return ChatModel();
    }
  }

  Future<Map> sendAMessage(
      {required String lang,
      required String message,
      required int chatID}) async {
    try {
      final response = await http.post(Uri.parse('$base_URL/chat/'), headers: {
        'apikey': apiKey,
        'lang': lang,
        'accept': 'application/json',
        'authorization':
            'Bearer ${sharedPreferences.getString('access_token')}',
        'timeZone': getTimezone(),
      }, body: {
        'message': message,
        'chat_id': chatID.toString()
      });
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else {
        print(jsonDecode(response.body));
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      print('Send Chat Messages Error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List<ChatModel>> getChatList({required String lang}) async {
    try {
      final response = await http.get(
        Uri.parse('$base_URL/chat/list'),
        headers: {
          'apikey': apiKey,
          'lang': lang,
          'accept': 'application/json',
          'authorization':
              'Bearer ${sharedPreferences.getString('access_token')}',
          'timeZone': getTimezone(),
        },
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        List<ChatModel> chats = [];
        data.forEach((element) {
          chats.add(ChatModel.fromJsonForList(element));
        });
        return chats;
      } else {
        print(jsonDecode(response.body));
        return [];
      }
    } catch (e) {
      print('Get Chat List Messages Error: $e');
      return [];
    }
    return [];
  }
}
