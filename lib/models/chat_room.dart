// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatRoom {
  final String id;
  final String token;
  ChatRoom({
    required this.id,
    required this.token,
  });

  ChatRoom copyWith({
    String? id,
    String? token,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'token': token,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatRoom(id: $id, token: $token)';

  @override
  bool operator ==(covariant ChatRoom other) {
    if (identical(this, other)) return true;

    return other.id == id && other.token == token;
  }

  @override
  int get hashCode => id.hashCode ^ token.hashCode;
}
