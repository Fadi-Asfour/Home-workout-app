// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_workout_app/Api%20services/chat_api.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/models/chat_model.dart';
import 'package:home_workout_app/models/message_model.dart';

class ChatViewModel with ChangeNotifier {
  ChatModel _chat = ChatModel();
  bool _isLoading = false;
  bool _isSendLoading = false;

  void setIsLaoding(value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsSendLaoding(value) {
    _isSendLoading = value;
    notifyListeners();
  }

  Future<void> setChat({required String lang, required int id}) async {
    setIsLaoding(true);
    _chat = await ChatAPI().getChat(lang: lang, userId: id);
    setIsLaoding(false);
  }

  Future<bool> sendAMessage(
      {required String lang,
      required int chatId,
      required BuildContext context,
      required String message}) async {
    setIsSendLaoding(true);
    final response = await ChatAPI()
        .sendAMessage(lang: lang, message: message, chatID: chatId);
    setIsSendLaoding(false);
    if (response['success']) {
      return true;
    } else {
      showSnackbar(Text(response['message'] ?? '').tr(), context);
      return false;
    }
  }

  void addToMessages({required var chatId, required var data}) {
    if (chatId == getChat.id) {
      _chat.messages.add(MessageModel.fromjson(data));
      notifyListeners();
    }
  }

  bool get getIsLoading => _isLoading;
  bool get getIsSendLoading => _isSendLoading;

  ChatModel get getChat => _chat;
}
