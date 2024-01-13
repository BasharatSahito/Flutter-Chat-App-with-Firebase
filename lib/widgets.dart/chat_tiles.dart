import 'package:chat_app/main.dart';
import 'package:chat_app/models/messages_model.dart';
import 'package:chat_app/models/users_model.dart';
import 'package:chat_app/screens/coversation_screen.dart';
import 'package:chat_app/services/apis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatTiles extends StatefulWidget {
  final UsersModel user;
  const ChatTiles({super.key, required this.user});

  @override
  State<ChatTiles> createState() => _ChatTilesState();
}

class _ChatTilesState extends State<ChatTiles> {
  List lastMessagesList = [];
  MessagesModel? message;
  final _dateFormat = DateFormat('HH:mm'); // Customize the format as needed

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

          // Format the timestamp
          String formattedTimestamp = message != null
              ? _dateFormat.format(message!.timestamp!.toDate())
              : '';

          return ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(08)),
            tileColor: Colors.white,
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mq.height * 0.3),
                border: Border.all(
                  color: Colors
                      .black87, // You can change the color of the border here
                  width: mq.width *
                      0.001, // You can adjust the width of the border
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.3),
                child: widget.user.photoUrl != null
                    ? Image.network(
                        widget.user.photoUrl!,
                        height: mq.height * 0.05,
                        errorBuilder: (context, error, stackTrace) {
                          // If there's an error loading the image, show the default icon
                          return Icon(Icons.person,
                              color: Colors.grey, size: mq.height * 0.05);
                        },
                      )
                    : Icon(Icons.account_circle,
                        size: mq.height * 0.05), // Default user icon
              ),
            ),
            title: Text(
              widget.user.name.toString(),
              style: TextStyle(
                fontSize: mq.width * 0.04,
              ),
            ),
            subtitle: Text(
              message?.msg.toString() ?? widget.user.email.toString(),
              style: TextStyle(
                fontSize: mq.width * 0.04,
              ),
            ),
            trailing: Text(
              formattedTimestamp,
              style: TextStyle(
                fontSize: mq.width * 0.04,
              ),
            ),
          );
        },
      ),
    );
  }
}
