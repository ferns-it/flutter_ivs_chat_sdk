package com.ferns.flutter_ivs_chat_sdk

import com.ferns.flutter_ivs_chat_sdk.models.ChatTokenProvider
import com.ferns.flutter_ivs_chat_sdk.sdk.FlutterIVSChatSDK
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/** FlutterIvsChatSdkPlugin */
class FlutterIvsChatSdkPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler,
    ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private val flutterIVSChatSDK: FlutterIVSChatSDK = FlutterIVSChatSDK()
    private val METHOD_CHANNEL = "com.ferns/flutter_ivs_chat_sdk"
    private val EVENT_CHANNEL = "com.ferns/flutter_ivs_chat_sdk_event_channel"


    companion object {
        var eventSink: EventChannel.EventSink? = null
    }


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL)
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(this)
    }

    @Suppress("UNCHECKED_CAST")
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "joinChatRoom" -> {
                val args: Map<*, *> = call.arguments as Map<*, *>
                val region: String = args["region"] as String
                val token: String = args["token"] as String
                val sessionExpTime: Long = args["sessionExpirationTime"] as Long
                val tokenExpirationTime: Long = args["tokenExpirationTime"] as Long
                val sessionExpDate = Date(sessionExpTime)
                val tokenExpDate = Date(tokenExpirationTime)
                val chatTokenProvider = ChatTokenProvider(
                    region = region,
                    token = token,
                    sessionExpirationTime = sessionExpDate,
                    tokenExpirationTime = tokenExpDate
                )
                flutterIVSChatSDK.joinChatRoom(chatTokenProvider, result)
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

    override fun onListen(args: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(args: Any?) {
        eventSink = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        flutterIVSChatSDK.onAttachedToActivity(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        flutterIVSChatSDK.onReattachedToActivityForConfigChanges(binding.activity)
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }
}
