package com.ferns.flutter_ivs_chat_sdk.sdk

import android.util.Log
import com.amazonaws.ivs.chat.messaging.ChatRoom
import com.amazonaws.ivs.chat.messaging.ChatRoomListener
import com.amazonaws.ivs.chat.messaging.ChatToken
import com.amazonaws.ivs.chat.messaging.ChatTokenCallback
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
import com.ferns.flutter_ivs_chat_sdk.models.ChatTokenProvider
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

class FlutterIVSChatSDK {

    private var chatRoom: ChatRoom? = null;


    private val roomListener = object : ChatRoomListener {
        override fun onConnecting(room: ChatRoom) {
            val eventDetails = {
                ""
            }
        }

        override fun onConnected(room: ChatRoom) {
            // Called when connection has been established
        }

        override fun onDisconnected(room: ChatRoom, reason: DisconnectReason) {
            // Called when a room has been disconnected
        }

        override fun onMessageReceived(room: ChatRoom, message: ChatMessage) {
            // Called when chat message has been received
        }

        override fun onUserDisconnected(room: ChatRoom, event: DisconnectUserEvent) {
            TODO("Not yet implemented")
        }

        override fun onEventReceived(room: ChatRoom, event: ChatEvent) {
            // Called when chat event has been received
        }

        override fun onMessageDeleted(room: ChatRoom, event: DeleteMessageEvent) {
            TODO("Not yet implemented")
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