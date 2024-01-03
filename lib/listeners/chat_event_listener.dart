import 'package:flutter_ivs_chat_sdk/models/chat_message.dart';
import 'package:flutter_ivs_chat_sdk/models/chat_room.dart';

import '../constants/enums.dart';
import '../models/chat_event.dart';

abstract class ChatEventListener {
  void onConnected(ChatRoom room);
  void onConnecting(ChatRoom room);
  void onDisconnected(ChatRoom room, DisconnectReason reason);
  void onEventReceived(ChatRoom room, ChatEvent event);
  void onMessageDeleted(ChatRoom room, ChatEvent event);
  void onMessageReceived(ChatRoom room, ChatMessage message);
  void onUserDisconnected(ChatRoom room, ChatEvent event);
}
