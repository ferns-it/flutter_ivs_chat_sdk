// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatTokenProvider {
  final String? region;
  final String token;
  final DateTime? sessionExpirationTime;
  final DateTime? tokenExpirationTime;

  ChatTokenProvider({
    required this.region,
    required this.token,
    this.sessionExpirationTime,
    this.tokenExpirationTime,
  });

  ChatTokenProvider copyWith({
    String? region,
    String? token,
    DateTime? sessionExpirationTime,
    DateTime? tokenExpirationTime,
  }) {
    return ChatTokenProvider(
      region: region ?? this.region,
      token: token ?? this.token,
      sessionExpirationTime:
          sessionExpirationTime ?? this.sessionExpirationTime,
      tokenExpirationTime: tokenExpirationTime ?? this.tokenExpirationTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'region': region,
      'token': token,
      'sessionExpirationTime': sessionExpirationTime?.millisecondsSinceEpoch,
      'tokenExpirationTime': tokenExpirationTime?.millisecondsSinceEpoch,
    };
  }

  factory ChatTokenProvider.fromMap(Map<String, dynamic> map) {
    return ChatTokenProvider(
      region: map['region'] != null ? map['region'] as String : null,
      token: map['token'] as String,
      sessionExpirationTime: map['sessionExpirationTime'] != null
          ? DateTime.parse(map['sessionExpirationTime'])
          : null,
      tokenExpirationTime: map['tokenExpirationTime'] != null
          ? DateTime.parse(map['tokenExpirationTime'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatTokenProvider.fromJson(String source) =>
      ChatTokenProvider.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatTokenProvider(region: $region, token: $token, sessionExpirationTime: $sessionExpirationTime, tokenExpirationTime: $tokenExpirationTime)';
  }

  @override
  bool operator ==(covariant ChatTokenProvider other) {
    if (identical(this, other)) return true;

    return other.region == region &&
        other.token == token &&
        other.sessionExpirationTime == sessionExpirationTime &&
        other.tokenExpirationTime == tokenExpirationTime;
  }

  @override
  int get hashCode {
    return region.hashCode ^
        token.hashCode ^
        sessionExpirationTime.hashCode ^
        tokenExpirationTime.hashCode;
  }
}
