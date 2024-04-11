import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_file_receiver/flutter_file_receiver.dart';
import 'package:flutter_file_receiver/flutter_file_receiver_platform_interface.dart';
import 'package:flutter_file_receiver/flutter_file_receiver_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFileReceiverPlatform
    with MockPlatformInterfaceMixin
    implements FlutterFileReceiverPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterFileReceiverPlatform initialPlatform = FlutterFileReceiverPlatform.instance;

  test('$MethodChannelFlutterFileReceiver is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFileReceiver>());
  });

  test('getPlatformVersion', () async {
    FlutterFileReceiver flutterFileReceiverPlugin = FlutterFileReceiver();
    MockFlutterFileReceiverPlatform fakePlatform = MockFlutterFileReceiverPlatform();
    FlutterFileReceiverPlatform.instance = fakePlatform;

    expect(await flutterFileReceiverPlugin.getPlatformVersion(), '42');
  });
}
