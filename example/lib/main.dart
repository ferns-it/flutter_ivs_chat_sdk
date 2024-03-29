import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ivs_chat_sdk/flutter_ivs_chat_sdk.dart';
import 'package:flutter_ivs_chat_sdk/models/chat_token_provider.dart';
import 'package:flutter_ivs_chat_sdk/models/send_message.dart';
import 'package:flutter_ivs_chat_sdk_example/ivs_chat_listener.dart';
import 'package:flutter_ivs_chat_sdk_example/widgets/chat_list_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => IVSChatEventListener(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterIvsChatSdk _flutterIvsChatSdkPlugin;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _flutterIvsChatSdkPlugin = FlutterIvsChatSdk.initialize(
        context.read<IVSChatEventListener>(),
      );
    });
    super.initState();
  }

  bool roomCreated = false;

  Future<void> createChatRoom() async {
    var url = Uri.parse(
      'https://streaming.createroyale.com/users/createchattoken',
    );
    var response = await http.post(
      url,
      body: {
        "userId": "12345",
        "roomIdentifier":
            "arn:aws:ivschat:ap-south-1:300996695197:room/7DYYSIl7C8Jv"
      },
    );

    var tokenProvider = ChatTokenProvider.fromJson(response.body);
    tokenProvider = tokenProvider.copyWith(region: "ap-south-1");
    if (tokenProvider.region == null) return;
    final chatResponse =
        await _flutterIvsChatSdkPlugin.createChatRoom(tokenProvider);
    setState(() {
      roomCreated = chatResponse.created;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IVS Chat SDK Example'),
          centerTitle: true,
        ),
        body: !roomCreated
            ? Center(
                child: FilledButton(
                  onPressed: createChatRoom,
                  child: const Text("Create & Join"),
                ),
              )
            : _ChatBoxWidget(
                flutterIvsChatSdkPlugin: _flutterIvsChatSdkPlugin,
              ),
      ),
    );
  }
}

class _ChatBoxWidget extends StatefulWidget {
  const _ChatBoxWidget({Key? key, required this.flutterIvsChatSdkPlugin})
      : super(key: key);

  final FlutterIvsChatSdk flutterIvsChatSdkPlugin;

  @override
  State<_ChatBoxWidget> createState() => _ChatBoxWidgetState();
}

class _ChatBoxWidgetState extends State<_ChatBoxWidget> {
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();

  static const usernames = ["jack", "Pranav", "Sankar"];

  Future<void> scrollAnimation() async {
    return await Future.delayed(
      const Duration(milliseconds: 100),
      () => scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear),
    );
  }

  Future<void> sendMessage() async {
    widget.flutterIvsChatSdkPlugin.sendMessage(
      SendMessage(content: textEditingController.text, attributes: {
        "name": usernames[Random().nextInt(3)],
        "userId": "63a402582183baa43df75b69",
        "image": "/assets/images/user.png"
      }),
    );
    textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Expanded(
              child: ChatListView(
            scrollController: scrollController,
            messageList: context.watch<IVSChatEventListener>().messages,
          )),
          Container(
            // height: 50,
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xFF333D56),
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 12.0),
                  child: const Icon(Icons.person),
                ),
                Expanded(
                  child: TextFormField(
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.text,
                    controller: textEditingController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 11.0),
                  child: Transform.rotate(
                    angle: -3.14 / 5,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: GestureDetector(
                        onTap: sendMessage,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
