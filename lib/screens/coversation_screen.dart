import 'package:chat_app/main.dart';
import 'package:chat_app/screens/call_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/messages_model.dart';

import '../models/users_model.dart';
import '../services/apis.dart';
import '../widgets.dart/message_bubble.dart';

class ConversationScreen extends StatefulWidget {
  final UsersModel user;

  const ConversationScreen({super.key, required this.user});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<MessagesModel> messagesList = [];
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: mq.width * 0.07,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
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
                child: Image.network(
                  widget.user.photoUrl.toString(),
                  height: mq.height * 0.05,
                ),
              ),
            ),
            SizedBox(
              width: mq.width * 0.02,
            ),
            Text(widget.user.name.toString())
          ],
        ),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallPage(
                        callID: APIs.getConversationID(widget.user.id!)),
                  ));
            },
            icon: const Icon(Icons.call),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: APIs.getAllMessages(widget.user),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  // if the data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    var data = snapshot.data?.docs;
                    messagesList = data
                            ?.map((e) => MessagesModel.fromJson(e.data()))
                            .toList() ??
                        [];

                    if (messagesList.isNotEmpty) {
                      return ListView.builder(
                        reverse: true, // Start from the bottom
                        itemCount: messagesList.length,
                        itemBuilder: (context, index) {
                          return MessageBubble(
                            messages: messagesList[index],
                          );
                        },
                      );
                    } else {
                      return const Center(
                          child: Text(
                        "Say Hi 👋",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ));
                    }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Card(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: "Type Something...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: mq.width * 0.03)),
                  ),
                )),
                SizedBox(
                  width: mq.width * 0.01,
                ),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 25,
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: mq.width * 0.07,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (messageController.text.isNotEmpty ||
                          messageController.text != "") {
                        if (messagesList.isEmpty) {
                          //on first message (add user to my_user collection of chat user)
                          APIs.sendFirstMessage(
                              widget.user, messageController.text.toString());
                        } else {
                          //simply send message
                          APIs.sendMessage(
                              widget.user,
                              messageController.text.toString(),
                              Timestamp.now());
                        }

                        messageController.clear();
                      }
                    },
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
