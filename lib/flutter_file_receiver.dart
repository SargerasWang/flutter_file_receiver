
import 'flutter_file_receiver_platform_interface.dart';

class FlutterFileReceiver {
  Future<String?> getPlatformVersion() {
    return FlutterFileReceiverPlatform.instance.getPlatformVersion();
  }
}
