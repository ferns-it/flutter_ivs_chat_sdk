// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChatEvent {
  final String id;
  final String? eventName;
  final bool isSystemEvent;
  final String? requestId;
  final String? reason;
  final String? userId;
  final String? messageId;
  final DateTime sendTime;
  final Map<String, String> attributes;
  ChatEvent({
    required this.id,
    required this.eventName,
    this.isSystemEvent = false,
    this.requestId,
    this.reason,
    this.userId,
    this.messageId,
    required this.sendTime,
    required this.attributes,
  });

  ChatEvent copyWith({
    String? id,
    String? eventName,
    bool? isSystemEvent,
    String? requestId,
    String? reason,
    String? userId,
    String? messageId,
    DateTime? sendTime,
    Map<String, String>? attributes,
  }) {
    return ChatEvent(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      isSystemEvent: isSystemEvent ?? this.isSystemEvent,
      requestId: requestId ?? this.requestId,
      reason: reason ?? this.reason,
      userId: userId ?? this.userId,
      messageId: messageId ?? this.messageId,
      sendTime: sendTime ?? this.sendTime,
      attributes: attributes ?? this.attributes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'eventName': eventName,
      'isSystemEvent': isSystemEvent,
      'requestId': requestId,
      'reason': reason,
      'userId': userId,
      'messageId': messageId,
      'sendTime': sendTime.millisecondsSinceEpoch,
      'attributes': attributes,
    };
  }

  factory ChatEvent.fromMap(Map<dynamic, dynamic> map) {
    return ChatEvent(
      id: map['id'] as String,
      eventName: map['eventName'] != null ? map['eventName'] as String : null,
      isSystemEvent: map['isSystemEvent'] as bool,
      requestId: map['requestId'] != null ? map['requestId'] as String : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      messageId: map['messageId'] != null ? map['messageId'] as String : null,
      sendTime: DateTime.fromMillisecondsSinceEpoch(map['sendTime'] as int),
      attributes:
          Map<String, String>.from((map['attributes'] as Map<String, String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatEvent.fromJson(String source) =>
      ChatEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatEvent(id: $id, eventName: $eventName, isSystemEvent: $isSystemEvent, requestId: $requestId, reason: $reason, userId: $userId, messageId: $messageId, sendTime: $sendTime, attributes: $attributes)';
  }

  @override
  bool operator ==(covariant ChatEvent other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.eventName == eventName &&
        other.isSystemEvent == isSystemEvent &&
        other.requestId == requestId &&
        other.reason == reason &&
        other.userId == userId &&
        other.messageId == messageId &&
        other.sendTime == sendTime &&
        mapEquals(other.attributes, attributes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        eventName.hashCode ^
        isSystemEvent.hashCode ^
        requestId.hashCode ^
        reason.hashCode ^
        userId.hashCode ^
        messageId.hashCode ^
        sendTime.hashCode ^
        attributes.hashCode;
  }
}
