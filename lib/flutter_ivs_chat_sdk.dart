// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter_ivs_chat_sdk/models/chat_room_response.dart';
import 'package:flutter_ivs_chat_sdk/models/send_message.dart';

import 'flutter_ivs_chat_sdk_platform_interface.dart';
import 'models/chat_token_provider.dart';

class FlutterIvsChatSdk {
  Future<String?> getPlatformVersion() {
    return FlutterIvsChatSdkPlatform.instance.getPlatformVersion();
  }

  Future<ChatRoomResponse> createChatRoom(ChatTokenProvider tokenProvider) {
    return FlutterIvsChatSdkPlatform.instance.createChatRoom(tokenProvider);
  }

  Future<void> sendMessage(SendMessage message) async {
    return FlutterIvsChatSdkPlatform.instance.sendMessage(message);
  }
}
