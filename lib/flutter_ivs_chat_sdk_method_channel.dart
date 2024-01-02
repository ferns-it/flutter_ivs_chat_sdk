import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ivs_chat_sdk/models/chat_token_provider.dart';
import 'package:flutter_ivs_chat_sdk/models/send_message.dart';

import 'flutter_ivs_chat_sdk_platform_interface.dart';

/// An implementation of [FlutterIvsChatSdkPlatform] that uses method channels.
class MethodChannelFlutterIvsChatSdk implements FlutterIvsChatSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ivs_chat_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> createChatRoom(ChatTokenProvider tokenProvider) async {
    final result = await methodChannel.invokeMethod(
      'createChatRoom',
      tokenProvider.toMap(),
    );
    inspect(result);
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
