package com.ferns.flutter_ivs_chat_sdk.models

data class ChatTokenProvider(
    val region: String,
    val token: String,
    val sessionExpirationTime: java.util.Date?,
    val tokenExpirationTime: java.util.Date?
)
