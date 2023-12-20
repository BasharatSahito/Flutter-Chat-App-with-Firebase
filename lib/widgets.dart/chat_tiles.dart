import 'package:chat_app/models/users_model.dart';
import 'package:chat_app/screens/coversation_screen.dart';
import 'package:flutter/material.dart';

class ChatTiles extends StatefulWidget {
  final UsersModel user;
  const ChatTiles({super.key, required this.user});

  @override
  State<ChatTiles> createState() => _ChatTilesState();
}

class _ChatTilesState extends State<ChatTiles> {
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
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(widget.user.name.toString()),
          subtitle: Text(widget.user.email.toString()),
        ),
      ),
    );
  }
}
