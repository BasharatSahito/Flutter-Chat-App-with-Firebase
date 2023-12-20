import 'package:chat_app/models/messages_model.dart';
import 'package:chat_app/models/users_model.dart';
import 'package:chat_app/screens/coversation_screen.dart';
import 'package:chat_app/services/apis.dart';
import 'package:flutter/material.dart';

class ChatTiles extends StatefulWidget {
  final UsersModel user;
  const ChatTiles({super.key, required this.user});

  @override
  State<ChatTiles> createState() => _ChatTilesState();
}

class _ChatTilesState extends State<ChatTiles> {
  List lastMessagesList = [];
  MessagesModel? message;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(user: widget.user),
            ));
      },
      child: StreamBuilder(
        stream: APIs.getLastMessage(widget.user),
        builder: (context, snapshot) {
          var data = snapshot.data?.docs;

          lastMessagesList =
              data?.map((e) => MessagesModel.fromJson(e.data())).toList() ?? [];

          if (lastMessagesList.isNotEmpty) {
            message = lastMessagesList[0];
          }

          return Card(
            elevation: 2,
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(widget.user.name.toString()),
              subtitle:
                  Text(message?.msg.toString() ?? widget.user.email.toString()),
            ),
          );
        },
      ),
    );
  }
}
