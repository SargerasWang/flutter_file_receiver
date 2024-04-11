import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_file_receiver_method_channel.dart';

abstract class FlutterFileReceiverPlatform extends PlatformInterface {
  /// Constructs a FlutterFileReceiverPlatform.
  FlutterFileReceiverPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFileReceiverPlatform _instance = MethodChannelFlutterFileReceiver();

  /// The default instance of [FlutterFileReceiverPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFileReceiver].
  static FlutterFileReceiverPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFileReceiverPlatform] when
  /// they register themselves.
  static set instance(FlutterFileReceiverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void receiveFileUrl(Function(String) onReceived){
    throw UnimplementedError('receiveFileUrl() has not been implemented.');
  }
}
