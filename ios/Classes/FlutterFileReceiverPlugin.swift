// FlutterFileReceiverPlugin.swift

import Flutter
import UIKit

public class FlutterFileReceiverPlugin: NSObject, FlutterPlugin, UIApplicationDelegate {
    private var channel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_file_receiver", binaryMessenger: registrar.messenger())
        let instance = FlutterFileReceiverPlugin()
        instance.channel = channel // 保存对MethodChannel的引用
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance) // 注册为应用代理
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
          result("iOS " + UIDevice.current.systemVersion)
        default:
          result(FlutterMethodNotImplemented)
        }
    }

    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle the URL
        if url.scheme == "file" {
            let filePath = url.path
            channel?.invokeMethod("receiveFileUrl", arguments: filePath)
        }
        return false
    }
}
