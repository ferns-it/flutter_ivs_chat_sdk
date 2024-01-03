// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatRoomResponse {
  final String? error;
  final bool created;
  ChatRoomResponse({
    this.error,
    required this.created,
  });

  ChatRoomResponse copyWith({
    String? error,
    bool? created,
  }) {
    return ChatRoomResponse(
      error: error ?? this.error,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'created': created,
    };
  }

  factory ChatRoomResponse.fromMap(Map<dynamic, dynamic> map) {
    return ChatRoomResponse(
      error: map['error'] != null ? map['error'] as String : null,
      created: map['created'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomResponse.fromJson(String source) =>
      ChatRoomResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatRoomResponse(error: $error, created: $created)';

  @override
  bool operator ==(covariant ChatRoomResponse other) {
    if (identical(this, other)) return true;

    return other.error == error && other.created == created;
  }

  @override
  int get hashCode => error.hashCode ^ created.hashCode;
}
