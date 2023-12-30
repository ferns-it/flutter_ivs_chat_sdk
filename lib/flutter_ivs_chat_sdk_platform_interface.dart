import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ivs_chat_sdk_method_channel.dart';

abstract class FlutterIvsChatSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterIvsChatSdkPlatform.
  FlutterIvsChatSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterIvsChatSdkPlatform _instance = MethodChannelFlutterIvsChatSdk();

  /// The default instance of [FlutterIvsChatSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterIvsChatSdk].
  static FlutterIvsChatSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterIvsChatSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterIvsChatSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
