import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ivs_chat_sdk/flutter_ivs_chat_data_types.dart';

import 'flutter_ivs_chat_sdk_platform_interface.dart';
import 'listeners/chat_event_listener.dart';

/// An implementation of [FlutterIvsChatSdkPlatform] that uses method channels.
class MethodChannelFlutterIvsChatSdk implements FlutterIvsChatSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.ferns/flutter_ivs_chat_sdk');

  /// The event channel used to interact with the native platform.
  @visibleForTesting
  final eventChannel =
      const EventChannel('com.ferns/flutter_ivs_chat_sdk_event_channel');

  @override
  final ChatEventListener listener;

  MethodChannelFlutterIvsChatSdk(this.listener) {
    eventChannel
        .receiveBroadcastStream()
        .listen((event) => processEvents(event as Map));
  }

  void processEvents(Map<dynamic, dynamic> event) {
    final eventName = event['event-name'] as String;
    switch (eventName) {
      case 'onConnecting':
        return listener.onConnecting(processChatRoom(event));
      case 'onConnected':
        return listener.onConnected(processChatRoom(event));
      case 'onDisconnected':
        return listener.onDisconnected(processChatRoom(event), event['reason']);
      case 'onMessageReceived':
        return listener.onMessageReceived(
          processChatRoom(event),
          ChatMessage.fromMap(event['message']),
        );
      case 'onUserDisconnected':
        return listener.onUserDisconnected(
          processChatRoom(event),
          processChatEvent(event),
        );
      case 'onEventReceived':
        return listener.onUserDisconnected(
          processChatRoom(event),
          processChatEvent(event),
        );
      case 'onMessageDeleted':
        return listener.onUserDisconnected(
          processChatRoom(event),
          processChatEvent(event),
        );
    }
  }

  ChatRoom processChatRoom(Map<dynamic, dynamic> event) {
    return ChatRoom.fromMap(event['room']);
  }

  ChatEvent processChatEvent(Map<dynamic, dynamic> event) {
    return ChatEvent.fromMap(event['event']);
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<ChatRoomResponse> createChatRoom(
    ChatTokenProvider tokenProvider,
  ) async {
    try {
      final result = await methodChannel.invokeMethod(
        'createChatRoom',
        tokenProvider.toMap(),
      );
      return ChatRoomResponse.fromMap(result);
    } on PlatformException catch (e) {
      return ChatRoomResponse.fromMap(e.details);
    }
  }

  @override
  Future<void> sendMessage(SendMessage message) async {
    await methodChannel.invokeMethod(
      'sendMessage',
      message.toMap(),
    );
  }
}
