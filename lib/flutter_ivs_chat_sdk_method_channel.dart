import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ivs_chat_sdk/models/chat_token_provider.dart';
import 'package:flutter_ivs_chat_sdk/models/send_message.dart';

import 'flutter_ivs_chat_sdk_platform_interface.dart';
import 'models/chat_room_response.dart';

/// An implementation of [FlutterIvsChatSdkPlatform] that uses method channels.
class MethodChannelFlutterIvsChatSdk implements FlutterIvsChatSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.ferns/flutter_ivs_chat_sdk');

  /// The event channel used to interact with the native platform.
  @visibleForTesting
  final eventChannel =
      const EventChannel('com.ferns/flutter_ivs_chat_sdk_event_channel');

  MethodChannelFlutterIvsChatSdk() {
    eventChannel.receiveBroadcastStream().listen((event) {
      log(event.toString());
    });
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
    final result = await methodChannel.invokeMethod(
      'sendMessage',
      message.toMap(),
    );
    inspect(result);
  }
}
