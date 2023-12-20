import 'package:chat_app/main.dart';
import 'package:chat_app/models/messages_model.dart';
import 'package:chat_app/services/apis.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final MessagesModel messages;
  const MessageBubble({super.key, required this.messages});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return APIs.auth.currentUser!.uid == widget.messages.sentfrom
        ? senderBubble()
        : recieverBubble();
  }

  Widget senderBubble() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.04, vertical: mq.width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(mq.width * 0.03),
                  topRight: Radius.circular(mq.width * 0.03),
                  // bo: Radius.circular(20),
                  bottomLeft: Radius.circular(mq.width * 0.03),
                ),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: mq.width * 0.06, vertical: mq.width * 0.03),
              child: Text(
                widget.messages.msg.toString(),
                style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget recieverBubble() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.04, vertical: mq.width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(mq.width * 0.03),
                  topRight: Radius.circular(mq.width * 0.03),
                  // bo: Radius.circular(20),
                  bottomRight: Radius.circular(mq.width * 0.03),
                ),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: mq.width * 0.06, vertical: mq.width * 0.03),
              child: Text(
                widget.messages.msg.toString(),
                style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
