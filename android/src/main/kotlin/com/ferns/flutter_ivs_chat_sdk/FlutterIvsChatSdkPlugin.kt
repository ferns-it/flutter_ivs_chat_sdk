package com.ferns.flutter_ivs_chat_sdk

import android.annotation.SuppressLint
import android.util.Log
import com.ferns.flutter_ivs_chat_sdk.models.ChatTokenProvider
import com.ferns.flutter_ivs_chat_sdk.sdk.FlutterIVSChatSDK
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/** FlutterIvsChatSdkPlugin */
class FlutterIvsChatSdkPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private val flutterIVSChatSDK: FlutterIVSChatSDK = FlutterIVSChatSDK()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_ivs_chat_sdk")
        channel.setMethodCallHandler(this)
    }

    @Suppress("UNCHECKED_CAST")
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "createChatRoom" -> {
                val args: Map<*, *> = call.arguments as Map<*, *>
                val region: String = args["region"] as String
                val token: String = args["token"] as String
                val sessionExpTime: String = args["sessionExpirationTime"] as String
                val tokenExpirationTime: String = args["tokenExpirationTime"] as String
                val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.getDefault())
                val parsedSessionExpTime: Date? = dateFormat.parse(sessionExpTime)
                val parsedTokenExpirationTime: Date? = dateFormat.parse(tokenExpirationTime)
                val chatTokenProvider = ChatTokenProvider(
                    region = region,
                    token = token,
                    sessionExpirationTime = parsedSessionExpTime,
                    tokenExpirationTime = parsedTokenExpirationTime
                )
                flutterIVSChatSDK.createChatRoom(chatTokenProvider, result)
            }

            "sendMessage" -> {
                val args: Map<*, *> = call.arguments as Map<*, *>
                val content: String = args["content"] as String
                val attributes: Map<String, String>? = args["attributes"] as Map<String, String>?
                flutterIVSChatSDK.sendMessage(content, attributes, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
