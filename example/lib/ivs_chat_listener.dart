import 'package:flutter/material.dart';
import 'package:flutter_ivs_chat_sdk/constants/enums.dart';
import 'package:flutter_ivs_chat_sdk/listeners/chat_event_listener.dart';
import 'package:flutter_ivs_chat_sdk/models/chat_event.dart';
import 'package:flutter_ivs_chat_sdk/models/chat_message.dart';
import 'package:flutter_ivs_chat_sdk/models/chat_room.dart';

class IVSChatEventListener extends ChangeNotifier with ChatEventListener {
  List<ChatMessage> messages = [];

  @override
  void onConnected(ChatRoom room) {}

  @override
  void onConnecting(ChatRoom room) {}

  @override
  void onDisconnected(ChatRoom room, DisconnectReason reason) {}

  @override
  void onEventReceived(ChatRoom room, ChatEvent event) {}

  @override
  void onMessageDeleted(ChatRoom room, ChatEvent event) {
    messages.removeWhere((msg) {
      return event.messageId != null && msg.id == event.messageId;
    });

    notifyListeners();
  }

  @override
  void onMessageReceived(ChatRoom room, ChatMessage message) {
    final isMessageAlreadyExist = messages.any((msg) => msg.id == message.id);
    if (!isMessageAlreadyExist) {
      messages.add(message);
      notifyListeners();
    }
  }

  @override
  void onUserDisconnected(ChatRoom room, ChatEvent event) {}
}
