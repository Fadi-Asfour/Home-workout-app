import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/chat_api.dart';
import 'package:home_workout_app/models/chat_model.dart';

class ChatListViewModel with ChangeNotifier {
  bool _isLoading = false;
  List<ChatModel> _chats = [];

  void setIsLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setChatList({required String lang}) async {
    setIsLoading(true);
    _chats = await ChatAPI().getChatList(lang: lang);
    log(_chats.toString());
    setIsLoading(false);
    notifyListeners();
  }

  bool get getIsLoading => _isLoading;
  List<ChatModel> get getChatList => _chats;
}
