import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ivs_chat_sdk/flutter_ivs_chat_sdk.dart';
import 'package:flutter_ivs_chat_sdk/models/chat_token_provider.dart';
import 'package:flutter_ivs_chat_sdk/models/send_message.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterIvsChatSdkPlugin = FlutterIvsChatSdk();

  Future<void> createChatRoom() async {
    var url =
        Uri.parse('https://streaming.createroyale.com/users/createchattoken');
    var response = await http.post(
      url,
      body: {
        "userId": "12345",
        "roomIdentifier":
            "arn:aws:ivschat:ap-south-1:300996695197:room/VXUofYh07zx3"
      },
    );

    var tokenProvider = ChatTokenProvider.fromJson(response.body);
    tokenProvider = tokenProvider.copyWith(region: "ap-south-1");
    if (tokenProvider.region == null) return;
    _flutterIvsChatSdkPlugin.createChatRoom(tokenProvider);
  }

  Future<void> sendMessage() async {
    final message = SendMessage(content: "How are u?", attributes: {
      "name": "Sankar",
      "userId": "63a402582183baa43df75b69",
      "image": "/assets/images/user.png"
    });
    await _flutterIvsChatSdkPlugin.sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text('IVS Chat SDK Example')),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FilledButton(
                onPressed: createChatRoom,
                child: const Text("Create Chat Room"),
              ),
              FilledButton(
                onPressed: sendMessage,
                child: const Text("Send Message"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
