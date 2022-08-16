import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/constants.dart';
import 'package:home_workout_app/view_models/Chat%20View%20Model/chat_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:home_workout_app/views/Posts%20View/post_view_widgets.dart';
import 'package:provider/provider.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';

class ChatView extends StatefulWidget {
  ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    log('Entered');

    Future.delayed(Duration.zero).then((value) {
      const String PUSHER_KEY = 'ssss';
      const String BEARER_TOKEN =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiYzJlNzExOGZhOGI3NjdmZGRlNzIwYzAyYjA0ZjUxZTk0MzkzMmFmNTJmYTMzMmFjNTg5MDMxODRjNTVjNjAwMTE1NWQyZDRjNmNiYmQ2ODYiLCJpYXQiOjE2NTk2MjAyNDIuMTc3Njg5LCJuYmYiOjE2NTk2MjAyNDIuMTc3Njk2LCJleHAiOjE2NjAyMjUwNDIuMTY1NDkyLCJzdWIiOiIxIiwic2NvcGVzIjpbIioiXX0.ZsfSuMD7iY_fRfIEkEuaADoImsH40_vubplRHmq5ukAhLe6KCXsy-yNaC4mpEUz3RYwFkQg2Tp1Fh7L4o_LNoaQalvciPuzDOKD7hBHZbDmOQPk9oE32n68FIO2zLJmH5gC82hhbjnoXvAcRd_91yRUAmeExGy7hqSgvrfiGpI0c3NxlsepITGBcDAFmd4999okZ4w6mZd1csF3HOHbMFoBNhvy-bB17LwZ3bm9jO-dLxBtiyDtT5Ng4iK5ghSmO2jR8IcBjR6fuqGmU0pLtUGjiz0Xwap5uD65Lnedsgko-6tHENYSyb-f0noAVs-cJbCdnkb3oGeIjywGGT4GtkeVSaeFriulovs87_7elhb63-XOKxrq8zLIp8p3V5-tYr5xysno1zZ7JQN2vjm6ZYtLOBXE_IMMzePFbJ0Lu4vr17xInFnvrpBqEakItLcwDvjG1yKPyQUrcFaDA77brqtbWP6EQm-ZfHgfhwIy5qQRRlCb6GdOBdeiOIPmEpND2nATU65P75LcSPHZEkWY02x7UY2WdcgiX7UsERll-xM5DD6EYleSojFc3Ey93IiohSvJRGUqwZvr08En2DmFUI5hWsENbAu0juOJ6JPXzUkgYghsiQBtpCnSN7XEo0Yju9Q4R-qpxBDbl_XAmAqogXCnheyRBK4ndu3ONcK1Ddtc';
      const String AUTH_URL = 'http://192.168.43.113:8000/broadcasting/auth';

      PusherOptions options = PusherOptions(
        host: '192.168.43.113',

        encrypted: false,
        wsPort: 6001,

        //wssPort: 6001,
        //host: AUTH_URL,
        auth: PusherAuth(
          AUTH_URL,
          // headers: {
          //   'Authorization': 'Bearer $BEARER_TOKEN',
          //   'apiKey':
          //       'THSzx8cmJny4DFmjvjX2calOKSduaJxb3YKC9sCuoCdEiF4J9w6qul5kRFwt1mUR'
          // },
        ),
      );

// Create pusher client
      PusherClient pusherClient = PusherClient(
        PUSHER_KEY,
        options,
        autoConnect: false,
        enableLogging: false,
      );

// Create echo instance
      Echo echo = Echo(
        broadcaster: EchoBroadcasterType.Pusher,
        client: pusherClient,
      );

// Listening public channel
      echo.channel('chat').listen('MessageEvent', (e) {
        log(int.tryParse(e.data[0].toString()).toString());
        Provider.of<ChatViewModel>(context, listen: false).addToMessages(
            chatId: int.tryParse(
                    jsonDecode(e.data.toString())['chat_id'].toString()) ??
                0,
            data: jsonDecode(e.data.toString()));
      });

// Accessing pusher instance
      echo.connector.pusher.onConnectionStateChange((state) {
        print(state!.currentState.toString());
      });
    });
    Future.delayed(Duration.zero).then((value) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      setState(() {
        userId = args['id'] ?? 0;
      });
      Provider.of<ChatViewModel>(context, listen: false)
          .setChat(lang: getLang(context), id: args['id'] ?? 0);
    });
  }

  TextEditingController _textEditingController = TextEditingController();

  int userId = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    log('Exit');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: double.infinity,
        height: 120,
        child: Consumer<ChatViewModel>(
          builder: (context, send, child) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                        maxLines: 1,
                        controller: _textEditingController,
                        title: 'Send a message'),
                  ),
                  send.getIsLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: bigLoader(color: orangeColor),
                        )
                      : IconButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            final response = await send.sendAMessage(
                                lang: getLang(context),
                                chatId: send.getChat.id,
                                context: context,
                                message: _textEditingController.text.trim());
                            if (response) _textEditingController.clear();
                          },
                          icon: Icon(
                            context.locale == const Locale('en')
                                ? Icons.arrow_circle_right_outlined
                                : Icons.arrow_circle_left_outlined,
                            size: 30,
                            color: orangeColor,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Consumer<ChatViewModel>(
          builder: (context, chat, child) => InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/anotherUserProfile',
                  arguments: {'id': chat.getChat.userId});
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(chat.getChat.userImg),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  chat.getChat.userName,
                  style: theme.textTheme.bodySmall!.copyWith(color: blueColor),
                ).tr(),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, chat, child) => chat.getIsLoading
            ? Center(
                child: bigLoader(color: orangeColor),
              )
            : (chat.getChat.messages.isEmpty
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'There are no messages',
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: greyColor),
                        ).tr(),
                        const SizedBox(
                          width: 5,
                        ),
                        TextButton(
                            onPressed: () async {
                              await Provider.of<ChatViewModel>(context,
                                      listen: false)
                                  .setChat(lang: getLang(context), id: userId);
                            },
                            child: Text(
                              'Refresh',
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: orangeColor),
                            ).tr())
                      ],
                    ),
                  )
                : RefreshIndicator(
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    color: orangeColor,
                    onRefresh: () async {
                      await Provider.of<ChatViewModel>(context, listen: false)
                          .setChat(lang: getLang(context), id: userId);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      reverse: true,
                      child: Column(
                        children: chat.getChat.messages
                            .map((e) => Padding(
                                  padding: EdgeInsets.only(
                                      top: 8,
                                      right: 8,
                                      left: 8,
                                      bottom: chat.getChat.messages
                                                  .indexOf(e) ==
                                              chat.getChat.messages.length - 1
                                          ? 115
                                          : 0),
                                  child: Align(
                                    alignment: Provider.of<ProfileViewModel>(
                                                    context,
                                                    listen: true)
                                                .getUserData
                                                .id ==
                                            e.userId
                                        ? Alignment.bottomRight
                                        : Alignment.bottomLeft,
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 200),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: blueColor, width: 1),
                                        borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(15),
                                            bottomLeft: Radius.circular(
                                                Provider.of<ProfileViewModel>(
                                                                context,
                                                                listen: true)
                                                            .getUserData
                                                            .id !=
                                                        e.userId
                                                    ? 0
                                                    : 15),
                                            topRight: const Radius.circular(15),
                                            bottomRight: Radius.circular(
                                                Provider.of<ProfileViewModel>(
                                                                context,
                                                                listen: true)
                                                            .getUserData
                                                            .id ==
                                                        e.userId
                                                    ? 0
                                                    : 15)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              Provider.of<ProfileViewModel>(
                                                              context,
                                                              listen: true)
                                                          .getUserData
                                                          .id !=
                                                      e.userId
                                                  ? CrossAxisAlignment.start
                                                  : CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              e.message,
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(color: blueColor),
                                            ),
                                            Text(
                                              e.created_at,
                                              style: theme.textTheme.bodySmall!
                                                  .copyWith(
                                                      color: greyColor,
                                                      fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  )),
      ),
    );
  }
}
