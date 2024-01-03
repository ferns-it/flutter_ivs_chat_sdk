package com.ferns.flutter_ivs_chat_sdk.sdk

import android.app.Activity
import android.util.Log
import com.amazonaws.ivs.chat.messaging.ChatRoom
import com.amazonaws.ivs.chat.messaging.ChatRoomListener
import com.amazonaws.ivs.chat.messaging.ChatToken
import com.amazonaws.ivs.chat.messaging.DeleteMessageCallback
import com.amazonaws.ivs.chat.messaging.DisconnectReason
import com.amazonaws.ivs.chat.messaging.DisconnectUserCallback
import com.amazonaws.ivs.chat.messaging.SendMessageCallback
import com.amazonaws.ivs.chat.messaging.entities.ChatError
import com.amazonaws.ivs.chat.messaging.entities.ChatEvent
import com.amazonaws.ivs.chat.messaging.entities.ChatMessage
import com.amazonaws.ivs.chat.messaging.entities.DeleteMessageEvent
import com.amazonaws.ivs.chat.messaging.entities.DisconnectUserEvent
import com.amazonaws.ivs.chat.messaging.requests.DeleteMessageRequest
import com.amazonaws.ivs.chat.messaging.requests.DisconnectUserRequest
import com.amazonaws.ivs.chat.messaging.requests.SendMessageRequest
import com.ferns.flutter_ivs_chat_sdk.FlutterIvsChatSdkPlugin
import com.ferns.flutter_ivs_chat_sdk.models.ChatTokenProvider
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

private const val TAG = "Flutter_IVS_Chat_SDK"


class FlutterIVSChatSDK() {

    private var chatRoom: ChatRoom? = null;
    private var activity: Activity? = null;


    private val roomListener = object : ChatRoomListener {
        override fun onConnecting(room: ChatRoom) {
            val roomDetails = mapOf<String, Any>(
                "id" to room.id,
                "state" to room.state.name
            )
            val eventDetails = mapOf<String, Any>(
                "event-name" to "onConnecting",
                "room" to roomDetails
            )

            sendEventToEventChannel(eventDetails)

        }

        override fun onConnected(room: ChatRoom) {
            val roomDetails = mapOf<String, Any>(
                "id" to room.id,
                "state" to room.state.name
            )
            val eventDetails = mapOf<String, Any>(
                "event-name" to "onConnected",
                "room" to roomDetails
            )
            sendEventToEventChannel(eventDetails)
        }

        override fun onDisconnected(room: ChatRoom, reason: DisconnectReason) {
            val roomDetails = mapOf<String, Any>(
                "id" to room.id,
                "state" to room.state.name
            )

            val eventDetails = mapOf<String, Any>(
                "event-name" to "onDisconnected",
                "room" to roomDetails,
                "reason" to reason.name,
            )
            sendEventToEventChannel(eventDetails)
        }

        override fun onMessageReceived(room: ChatRoom, message: ChatMessage) {
            val roomDetails = mapOf<String, Any>(
                "id" to room.id,
                "state" to room.state.name
            )
            val senderDetails = mutableMapOf<String, Any>(
                "userId" to message.sender.userId,
                "sendTime" to message.sendTime.toString()
            )
            message.sender.attributes?.let { senderDetails["attributes"] = it }

            val chatMessage = mutableMapOf(
                "id" to message.id,
                "message" to message.content,
                "sender" to senderDetails
            )


            message.attributes?.let { chatMessage["attributes"] = it }

            val eventDetails = mapOf(
                "event-name" to "onMessageReceived",
                "room" to roomDetails,
                "message" to chatMessage,
            )
            sendEventToEventChannel(eventDetails)


        }

        override fun onUserDisconnected(room: ChatRoom, event: DisconnectUserEvent) {
            val roomDetails = mapOf<String, Any>(
                "id" to room.id,
                "state" to room.state.name
            )

            val userDisconnectEventDetails = mutableMapOf<String, Any>(
                "id" to event.id,
                "userId" to event.userId,
                "sendTime" to event.sendTime.toString()
            )

            event.attributes?.let { userDisconnectEventDetails["attributes"] = it }
            event.reason?.let { userDisconnectEventDetails["reason"] = it }
            event.requestId?.let { userDisconnectEventDetails["requestId"] = it }

            val eventDetails = mapOf(
                "event-name" to "onUserDisconnected",
                "room" to roomDetails,
                "event" to userDisconnectEventDetails
            )
            sendEventToEventChannel(eventDetails)
        }

        override fun onEventReceived(room: ChatRoom, event: ChatEvent) {
            val roomDetails = mapOf<String, Any>(
                "id" to room.id,
                "state" to room.state.name
            )
            val receivedEventDetails = mutableMapOf<String, Any>(
                "id" to event.id,
                "eventName" to event.eventName,
                "sendTime" to event.sendTime.toString()
            )

            event.attributes?.let { receivedEventDetails["attributes"] = it }
            event.requestId?.let { receivedEventDetails["requestId"] = it }

            val eventDetails = mapOf(
                "event-name" to "onEventReceived",
                "room" to roomDetails,
                "event" to receivedEventDetails
            )
            sendEventToEventChannel(eventDetails)
        }

        override fun onMessageDeleted(room: ChatRoom, event: DeleteMessageEvent) {
            val roomDetails = mapOf<String, Any>(
                "id" to room.id,
                "state" to room.state.name
            )
            val receivedEventDetails = mutableMapOf<String, Any>(
                "id" to event.id,
                "messageId" to event.messageId,
                "sendTime" to event.sendTime.toString()
            )

            event.attributes?.let { receivedEventDetails["attributes"] = it }
            event.reason?.let { receivedEventDetails["reason"] = it }
            event.requestId?.let { receivedEventDetails["requestId"] = it }

            val eventDetails = mapOf(
                "event-name" to "onMessageDeleted",
                "room" to roomDetails,
                "event" to receivedEventDetails
            )
            sendEventToEventChannel(eventDetails)
        }
    }

    fun onAttachedToActivity(activity: Activity) {
        this.activity = activity
        Log.d(TAG, "Activity Attached!")
    }

    fun onReattachedToActivityForConfigChanges(activity: Activity) {
        this.activity = activity
        Log.d(TAG, "Activity Re-Attached!")
    }


    fun sendEventToEventChannel(eventDetails: Map<String, Any>) {
        activity?.runOnUiThread {
            FlutterIvsChatSdkPlugin.eventSink?.success(eventDetails)
        }
    }


    fun createChatRoom(chatTokenProvider: ChatTokenProvider, result: MethodChannel.Result) {
        try {
            val token = ChatToken(
                chatTokenProvider.token,
                chatTokenProvider.sessionExpirationTime,
                chatTokenProvider.tokenExpirationTime
            )
            chatRoom = ChatRoom(
                regionOrUrl = chatTokenProvider.region,
                tokenProvider = { it.onSuccess(token) }
            ).apply { listener = roomListener }
            chatRoom!!.connect()
            result.success(mapOf("error" to null, "created" to true))
        } catch (e: Exception) {
            result.error(
                "Chat Room Creation Failed!",
                e.localizedMessage,
                mapOf("error" to e.localizedMessage, "created" to false)
            )
        }
    }

    fun sendMessage(
        content: String,
        attributes: Map<String, String>?,
        result: MethodChannel.Result
    ) {
        try {
            if (chatRoom == null) {
                return result.error(
                    "Chat room not initialized!",
                    "Invoke 'createChatRoom' method to create chat room",
                    mapOf(
                        "error" to "Invoke 'createChatRoom' method to create chat room",
                        "success" to false,
                        "rejected" to false
                    )
                )
            }

            val sendMessageResult = SendMessageRequest(content, attributes)
            chatRoom!!.sendMessage(sendMessageResult, object : SendMessageCallback {
                override fun onConfirmed(request: SendMessageRequest, response: ChatMessage) {
                    return result.success(messageToMap(response))
                }

                override fun onRejected(request: SendMessageRequest, error: ChatError) {
                    return result.error(
                        "Send Message Rejected",
                        error.errorMessage,
                        mapOf(
                            "error" to (error.errorMessage),
                            "success" to false,
                            "rejected" to true
                        )
                    )
                }
            })
        } catch (e: Exception) {
            return result.error(
                "Send Message Failed",
                e.localizedMessage ?: "Unknown error",
                mapOf(
                    "error" to (e.localizedMessage ?: "Unknown error"),
                    "success" to false,
                    "rejected" to false
                )
            )
        }
    }


    private fun messageToMap(message: ChatMessage): Map<String, *> {
        val id = message.id
        val content = message.content
        val attributes = message.attributes
        val requestId = message.requestId
        val sendTime = message.sendTime
        val senderUserId = message.sender.userId

        return mapOf(
            "id" to id,
            "content" to content,
            "attributes" to attributes,
            "requestId" to requestId,
            "sendTime" to sendTime.toString(),
            "senderUserId" to senderUserId
        )
    }


    fun deleteChatMessage(messageId: String, reason: String, result: MethodChannel.Result) {
        try {
            if (chatRoom == null) {
                return result.error(
                    "Chat room not initialized!",
                    "Invoke 'createChatRoom' method to create chat room",
                    mapOf(
                        "error" to "Invoke 'createChatRoom' method to create chat room",
                        "success" to false,
                        "rejected" to false
                    )
                )
            }
            val request = DeleteMessageRequest(messageId, reason)
            chatRoom!!.deleteMessage(request, object : DeleteMessageCallback {
                override fun onConfirmed(
                    request: DeleteMessageRequest,
                    response: DeleteMessageEvent
                ) {
                    return result.success(deletedMessageEvent(response))
                }

                override fun onRejected(request: DeleteMessageRequest, error: ChatError) {
                    return result.error(
                        "Delete Message Rejected",
                        error.errorMessage,
                        mapOf(
                            "error" to (error.errorMessage),
                            "success" to false,
                            "rejected" to true
                        )
                    )
                }
            })
        } catch (e: Exception) {
            return result.error(
                "Delete Message Rejected",
                e.localizedMessage ?: "Unknown error",
                mapOf(
                    "error" to (e.localizedMessage ?: "Unknown error"),
                    "success" to false,
                    "rejected" to false
                )
            )
        }

    }


    private fun deletedMessageEvent(message: DeleteMessageEvent): Map<String, *> {
        val id = message.id
        val attributes = message.attributes
        val requestId = message.requestId
        val sendTime = message.sendTime
        val reason = message.reason
        return mapOf(
            "id" to id,
            "attributes" to attributes,
            "requestId" to requestId,
            "sendTime" to sendTime.toString(),
            "reason" to reason,
        )
    }


    private fun disconnectUserToMap(user: DisconnectUserEvent): Map<String, *> {
        val id = user.id
        val userId = user.userId
        val attributes = user.attributes
        val requestId = user.requestId
        val sendTime = user.sendTime
        val reason = user.reason


        return mapOf(
            "id" to id,
            "userId" to userId,
            "attributes" to attributes,
            "requestId" to requestId,
            "sendTime" to sendTime.toString(),
            "reason" to reason,
        )
    }

    fun disconnectOtherUser(userId: String, reason: String, result: MethodChannel.Result) {
        try {
            if (chatRoom == null) {
                return result.error(
                    "Chat room not initialized!",
                    "Invoke 'createChatRoom' method to create chat room",
                    mapOf(
                        "error" to "Invoke 'createChatRoom' method to create chat room",
                        "success" to false,
                        "rejected" to false
                    )
                )
            }
            val request = DisconnectUserRequest(userId, reason)
            chatRoom!!.disconnectUser(request, object : DisconnectUserCallback {
                override fun onConfirmed(
                    request: DisconnectUserRequest,
                    response: DisconnectUserEvent
                ) {
                    return result.success(disconnectUserToMap(response))
                }

                override fun onRejected(request: DisconnectUserRequest, error: ChatError) {
                    return result.error(
                        "Disconnect Other User Rejected",
                        error.errorMessage,
                        mapOf(
                            "error" to (error.errorMessage),
                            "success" to false,
                            "rejected" to true
                        )
                    )
                }
            })
        } catch (e: Exception) {
            return result.error(
                "Disconnect Other User Failure",
                e.localizedMessage ?: "Unknown error",
                mapOf(
                    "error" to (e.localizedMessage ?: "Unknown error"),
                    "success" to false,
                    "rejected" to false
                )
            )
        }
    }

    fun disconnectChatRoom(result: MethodChannel.Result) {
        try {
            if (chatRoom == null) {
                return result.error(
                    "Chat room not initialized!",
                    "Invoke 'createChatRoom' method to create chat room",
                    mapOf(
                        "error" to "Invoke 'createChatRoom' method to create chat room",
                        "success" to false
                    )
                )
            }
            chatRoom!!.disconnect()
            result.success(mapOf("error" to null, "disconnected" to true))
        } catch (e: Exception) {
            return result.error(
                "Disconnect Chat Room Failure",
                e.localizedMessage ?: "Unknown error",
                mapOf(
                    "error" to (e.localizedMessage ?: "Unknown error"),
                    "disconnected" to false
                )
            )
        }
    }
}