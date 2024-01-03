// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../constants/enums.dart';

class ChatRoom {
  final String id;
  final ChatRoomState state;
  ChatRoom({
    required this.id,
    required this.state,
  });

  ChatRoom copyWith({
    String? id,
    ChatRoomState? state,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'state': state.name,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] as String,
      state: ChatRoomState.fromName(map['state'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatRoom(id: $id, state: $state)';

  @override
  bool operator ==(covariant ChatRoom other) {
    if (identical(this, other)) return true;

    return other.id == id && other.state == state;
  }

  @override
  int get hashCode => id.hashCode ^ state.hashCode;
}
