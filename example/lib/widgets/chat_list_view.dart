import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ivs_chat_sdk_example/widgets/receiver_row_view.dart';
import 'package:flutter_ivs_chat_sdk_example/widgets/send_row_view.dart';
import 'package:flutter_ivs_chat_sdk/models/chat_message.dart';

class ChatListView extends StatelessWidget {
  const ChatListView(
      {Key? key, required this.scrollController, required this.messageList})
      : super(key: key);

  final ScrollController scrollController;

  final List<ChatMessage> messageList;

  static const currentUserId = '12345';

  @override
  Widget build(BuildContext context) {
    inspect(messageList);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      itemCount: messageList.length,
      itemBuilder: (context, index) =>
          (messageList[index].sender.userId == currentUserId)
              ? SenderRowView(senderMessage: messageList[index])
              : ReceiverRowView(receiverMessage: messageList[index].message),
    );
  }
}
