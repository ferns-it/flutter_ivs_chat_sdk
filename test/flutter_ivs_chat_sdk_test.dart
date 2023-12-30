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
}

void main() {
  final FlutterIvsChatSdkPlatform initialPlatform = FlutterIvsChatSdkPlatform.instance;

  test('$MethodChannelFlutterIvsChatSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterIvsChatSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterIvsChatSdk flutterIvsChatSdkPlugin = FlutterIvsChatSdk();
    MockFlutterIvsChatSdkPlatform fakePlatform = MockFlutterIvsChatSdkPlatform();
    FlutterIvsChatSdkPlatform.instance = fakePlatform;

    expect(await flutterIvsChatSdkPlugin.getPlatformVersion(), '42');
  });
}
