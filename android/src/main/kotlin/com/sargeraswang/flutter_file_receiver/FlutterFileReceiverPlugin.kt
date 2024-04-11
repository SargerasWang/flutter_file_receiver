package com.sargeraswang.flutter_file_receiver

import androidx.annotation.NonNull
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import android.provider.OpenableColumns
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.os.Parcelable
import android.provider.MediaStore
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** FlutterFileReceiverPlugin */
class FlutterFileReceiverPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_file_receiver")
    channel.setMethodCallHandler(this)
    Log.d("FileReceiverPlugin", "Plugin attached to engine.")
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    Log.d("FileReceiverPlugin", "Plugin detached from engine.")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    // 监听Intent
    handleSendOrViewIntent(activity?.intent)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  private fun handleSendOrViewIntent(intent: Intent?) {
    Log.d("FileReceiverPlugin", "Handling intent: $intent")
    when (intent?.action) {
      Intent.ACTION_SEND -> {
        if (intent.type != null) {
          // 如果是发送文件
          (intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM) as? Uri)?.let { uri ->
            processUri(uri)
          }
        }
      }
      Intent.ACTION_VIEW -> {
        // 如果是查看文件
        intent.data?.let { uri ->
          processUri(uri)
        }
      }
    }
  }

  private fun processUri(uri: Uri) {
    Log.d("FileReceiverPlugin", "Processing URI: $uri")
    val contentResolver = activity?.contentResolver
    val mimeType = contentResolver?.getType(uri)
    Log.d("FileReceiverPlugin", "Content type: $mimeType")

    // 尝试获取文件名
    val cursor = contentResolver?.query(uri, null, null, null, null)
    var fileName = "tempFile" // 默认文件名
    cursor?.use {
      val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
      if (nameIndex != -1 && it.moveToFirst()) {
        fileName = it.getString(nameIndex) // 获取包含扩展名的完整文件名
      }
    }

    // 复制文件到应用内部存储
    val file = File(activity?.filesDir, fileName)
    try {
      contentResolver?.openInputStream(uri)?.use { inputStream ->
        FileOutputStream(file).use { outputStream ->
          inputStream.copyTo(outputStream)
        }
      }
      // 将文件路径传递给Flutter
      channel.invokeMethod("receiveFileUrl", file.absolutePath)
    } catch (e: Exception) {
      Log.e("FileReceiverPlugin", "Error processing file URI", e)
    }
  }
}

