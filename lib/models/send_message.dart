// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SendMessage {
  final String content;
  final Map<String, String>? attributes;
  SendMessage({
    required this.content,
    this.attributes,
  });

  SendMessage copyWith({
    String? content,
    Map<String, String>? attributes,
  }) {
    return SendMessage(
      content: content ?? this.content,
      attributes: attributes ?? this.attributes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'attributes': attributes,
    };
  }

  factory SendMessage.fromMap(Map<String, dynamic> map) {
    return SendMessage(
      content: map['content'] as String,
      attributes: map['attributes'] != null
          ? Map<String, String>.from((map['attributes'] as Map<String, String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SendMessage.fromJson(String source) =>
      SendMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SendMessage(content: $content, attributes: $attributes)';

  @override
  bool operator ==(covariant SendMessage other) {
    if (identical(this, other)) return true;

    return other.content == content && mapEquals(other.attributes, attributes);
  }

  @override
  int get hashCode => content.hashCode ^ attributes.hashCode;
}
