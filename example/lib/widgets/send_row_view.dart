import 'package:flutter/material.dart';
import 'package:flutter_ivs_chat_sdk/flutter_ivs_chat_data_types.dart';
import 'package:intl/intl.dart';

class SenderRowView extends StatelessWidget {
  const SenderRowView({Key? key, required this.senderMessage})
      : super(key: key);

  final ChatMessage senderMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 15,
          fit: FlexFit.tight,
          child: Container(
            width: 50.0,
          ),
        ),
        Flexible(
          flex: 72,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 8.0, right: 5.0, top: 8.0, bottom: 2.0),
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 9.0, bottom: 9.0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xFF7CE994),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Text(
                      senderMessage.message,
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                ],
              ),
              senderMessage.sendTime != null
                  ? Container(
                      margin: const EdgeInsets.only(right: 10.0, bottom: 8.0),
                      child: Text(
                        formatTime(senderMessage.sendTime!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7.0,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          //
        ),
        Flexible(
          flex: 20,
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 1.0, bottom: 9.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF90C953),
              child: Text(senderMessage.attributes?['name']?[0] ?? "X",
                  style: const TextStyle(
                    color: Colors.black,
                  )),
            ),
          ),
        )
      ],
    );
  }

  String formatTime(DateTime dateTime) {
    // Define the format for the time
    DateFormat timeFormat = DateFormat('h:mm:ss a');

    // Format the DateTime object to a string
    String formattedTime = timeFormat.format(dateTime);

    return formattedTime;
  }
}
