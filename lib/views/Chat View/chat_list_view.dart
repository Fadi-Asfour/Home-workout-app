import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:home_workout_app/components.dart';
import 'package:home_workout_app/view_models/Chat%20View%20Model/chat_list_view_model.dart';
import 'package:home_workout_app/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class ChatListView extends StatefulWidget {
  ChatListView({Key? key}) : super(key: key);

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<ChatListViewModel>(context, listen: false)
          .setChatList(lang: getLang(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Chats',
          style: theme.textTheme.bodyMedium!.copyWith(color: orangeColor),
        ).tr(),
      ),
      body: Consumer<ChatListViewModel>(
        builder: (context, chats, child) => chats.getIsLoading
            ? Center(
                child: bigLoader(color: orangeColor),
              )
            : (chats.getChatList.isEmpty
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'There are no chats',
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: greyColor),
                        ).tr(),
                        const SizedBox(
                          width: 5,
                        ),
                        TextButton(
                            onPressed: () async {
                              await chats.setChatList(lang: getLang(context));
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
                    color: orangeColor,
                    onRefresh: () async {
                      await chats.setChatList(lang: getLang(context));
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      child: Column(
                        children: chats.getChatList
                            .map(
                              (e) => InkWell(
                                onTap: () {
                                  if (Provider.of<ProfileViewModel>(context,
                                              listen: false)
                                          .getUserData
                                          .id ==
                                      e.from) {
                                    Navigator.pushNamed(context, '/chat',
                                        arguments: {'id': e.to});
                                  } else {
                                    Navigator.pushNamed(context, '/chat',
                                        arguments: {'id': e.from});
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: blueColor, width: 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ListTile(
                                        leading: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/anotherUserProfile',
                                                arguments: {'id': e.userId});
                                          },
                                          child: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(e.userImg),
                                          ),
                                        ),
                                        trailing: Text(
                                          e.last_date,
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(
                                                  color: greyColor,
                                                  fontSize: 10),
                                        ),
                                        title: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/anotherUserProfile',
                                                arguments: {'id': e.userId});
                                          },
                                          child: Text(
                                            e.userName,
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(color: orangeColor),
                                          ),
                                        ),
                                        subtitle: Text(
                                          e.last_message,
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(color: blueColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )),
      ),
    );
  }
}
