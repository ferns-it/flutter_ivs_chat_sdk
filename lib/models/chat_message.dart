// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_ivs_chat_sdk/models/chat_user.dart';

class ChatMessage {
  final String message;
  final Map<String, String>? attributes;
  final ChatUser sender;

  ChatMessage({
    required this.message,
    this.attributes,
    required this.sender,
  });

  ChatMessage copyWith({
    String? message,
    Map<String, String>? attributes,
    ChatUser? sender,
  }) {
    return ChatMessage(
      message: message ?? this.message,
      attributes: attributes ?? this.attributes,
      sender: sender ?? this.sender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'attributes': attributes,
      'sender': sender.toMap(),
    };
  }

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      message: map['message'] as String,
      attributes: map['attributes'] != null
          ? Map<String, String>.from((map['attributes'] as Map<String, String>))
          : null,
      sender: ChatUser.fromMap(map['sender'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatMessage(message: $message, attributes: $attributes, sender: $sender)';

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        mapEquals(other.attributes, attributes) &&
        other.sender == sender;
  }

  @override
  int get hashCode => message.hashCode ^ attributes.hashCode ^ sender.hashCode;
}
