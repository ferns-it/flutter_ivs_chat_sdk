// ignore_for_file: constant_identifier_names
enum ChatRoomState {
  DISCONNECTED,
  CONNECTING,
  CONNECTED;

  static ChatRoomState fromName(String name) {
    return ChatRoomState.values.firstWhere((e) => e.name == name);
  }
}

enum DisconnectReason {
  CLIENT_DISCONNECT,
  SERVER_DISCONNECT,
  SOCKET_ERROR,
  FETCH_TOKEN_ERROR;

  DisconnectReason fromLabel(String label) {
    return DisconnectReason.values.firstWhere((e) => e.name == label);
  }
}
