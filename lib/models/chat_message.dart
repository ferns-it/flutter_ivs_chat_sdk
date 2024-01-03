// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_ivs_chat_sdk/models/chat_user.dart';

class ChatMessage {
  final String id;
  final String message;
  final Map<String, String>? attributes;
  final DateTime sendTime;
  final ChatUser sender;

  ChatMessage({
    required this.id,
    required this.message,
    this.attributes,
    required this.sendTime,
    required this.sender,
  });

  ChatMessage copyWith({
    String? id,
    String? message,
    Map<String, String>? attributes,
    DateTime? sendTime,
    ChatUser? sender,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      attributes: attributes ?? this.attributes,
      sendTime: sendTime ?? this.sendTime,
      sender: sender ?? this.sender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'attributes': attributes,
      'sendTime': sendTime.millisecondsSinceEpoch,
      'sender': sender.toMap(),
    };
  }

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      message: map['message'] as String,
      attributes: map['attributes'] != null
          ? Map<String, String>.from((map['attributes'] as Map<dynamic, String>))
          : null,
      sendTime: DateTime.parse(map['sendTime']),
      sender: ChatUser.fromMap(map['sender'] as Map<dynamic, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatMessage(id: $id, message: $message, attributes: $attributes, sendTime: $sendTime, sender: $sender)';
  }

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.message == message &&
        mapEquals(other.attributes, attributes) &&
        other.sendTime == sendTime &&
        other.sender == sender;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        attributes.hashCode ^
        sendTime.hashCode ^
        sender.hashCode;
  }
}
