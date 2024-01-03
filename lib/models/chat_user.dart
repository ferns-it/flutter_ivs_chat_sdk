// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChatUser {
  final String userId;
  final Map<String, String>? attributes;
  ChatUser({
    required this.userId,
    this.attributes,
  });

  ChatUser copyWith({
    String? userId,
    Map<String, String>? attributes,
  }) {
    return ChatUser(
      userId: userId ?? this.userId,
      attributes: attributes ?? this.attributes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'attributes': attributes,
    };
  }

  factory ChatUser.fromMap(Map<dynamic, dynamic> map) {
    return ChatUser(
      userId: map['userId'] as String,
      attributes: map['attributes'] != null
          ? Map<String, String>.from((map['attributes'] as Map<String, String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatUser(userId: $userId, attributes: $attributes)';

  @override
  bool operator ==(covariant ChatUser other) {
    if (identical(this, other)) return true;

    return other.userId == userId && mapEquals(other.attributes, attributes);
  }

  @override
  int get hashCode => userId.hashCode ^ attributes.hashCode;
}
