import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_file_receiver_platform_interface.dart';

/// An implementation of [FlutterFileReceiverPlatform] that uses method channels.
class MethodChannelFlutterFileReceiver extends FlutterFileReceiverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_file_receiver');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
