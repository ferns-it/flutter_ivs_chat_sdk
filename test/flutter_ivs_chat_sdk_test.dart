import 'package:flutter_ivs_chat_sdk/models/chat_token_provider.dart';
import 'package:flutter_ivs_chat_sdk/models/send_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ivs_chat_sdk/flutter_ivs_chat_sdk.dart';
import 'package:flutter_ivs_chat_sdk/flutter_ivs_chat_sdk_platform_interface.dart';
import 'package:flutter_ivs_chat_sdk/flutter_ivs_chat_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterIvsChatSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterIvsChatSdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> createChatRoom(ChatTokenProvider tokenProvider) {
    // TODO: implement createChatRoom
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(SendMessage message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}

void main() {
  final FlutterIvsChatSdkPlatform initialPlatform =
      FlutterIvsChatSdkPlatform.instance;

  test('$MethodChannelFlutterIvsChatSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterIvsChatSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterIvsChatSdk flutterIvsChatSdkPlugin = FlutterIvsChatSdk();
    MockFlutterIvsChatSdkPlatform fakePlatform =
        MockFlutterIvsChatSdkPlatform();
    FlutterIvsChatSdkPlatform.instance = fakePlatform;

    expect(await flutterIvsChatSdkPlugin.getPlatformVersion(), '42');
  });
}
