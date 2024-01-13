import 'package:chat_app/main.dart';
import 'package:chat_app/models/my_user_model.dart';
import 'package:chat_app/models/users_model.dart';
import 'package:chat_app/screens/user_profile.dart';
import 'package:chat_app/services/apis.dart';
import 'package:chat_app/widgets.dart/chat_tiles.dart';
import 'package:chat_app/widgets.dart/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  List<UsersModel> userDataList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0DFE1),
      appBar: AppBar(
        title: const Text(
          "Chat App",
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: mq.width * 0.02),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfile(),
                    ));
              },
              child: CircleAvatar(
                radius: mq.width * 0.05,
                child: ClipOval(
                  child: Image.network(
                    APIs.auth.currentUser?.photoURL.toString() ?? "",
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: LiquidPullToRefresh(
        onRefresh: () {
          setState(() {});
          return Future.delayed(const Duration(seconds: 1));
        },
        color: Colors.deepPurple,
        backgroundColor: Colors.deepPurple[200],
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        height: 150,
        child: StreamBuilder(
          stream: APIs.getMyUsersId(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());

              case ConnectionState.active:
              case ConnectionState.done:
                var data = snapshot.data?.docs;

                List<Timestamp?> timestamps = data
                        ?.map((e) => e.data()["timestamp"] as Timestamp?)
                        .toList() ??
                    [];

                return StreamBuilder(
                  stream: APIs.getAllUsers(
                      snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      // if the data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.done:
                        var data = snapshot.data?.docs;

                        userDataList = data?.map((e) {
                              var userModel = UsersModel.fromJson(e.data());
                              if (timestamps.isNotEmpty) {
                                userModel.myUsers = [
                                  MyUserModel(timestamp: timestamps.removeAt(0))
                                ];
                              }
                              return userModel;
                            }).toList() ??
                            [];

                        userDataList.sort((a, b) {
                          final timestampA = a.myUsers?.first.timestamp;
                          final timestampB = b.myUsers?.first.timestamp;

                          if (timestampA == null && timestampB == null) {
                            return 0;
                          }
                          if (timestampA == null) return 1;
                          if (timestampB == null) return -1;

                          // Sort in descending order based on seconds
                          return timestampB.seconds
                              .compareTo(timestampA.seconds);
                        });

                        if (userDataList.isNotEmpty) {
                          return ListView.builder(
                            itemCount: userDataList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: mq.width * 0.03,
                                      vertical: mq.height * 0.01,
                                    ),
                                    child: ChatTiles(user: userDataList[index]),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text("NO CONNECTIONS FOUND"));
                        }
                    }
                  },
                );
            }
          },
        ),
      ),
      //floating button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            onPressed: () {
              _addChatUserDialog();
            },
            child: const Icon(Icons.add_comment_rounded)),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon:
                        const Icon(Icons.email, color: Colors.deepPurple),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackBar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                    ))
              ],
            ));
  }
}
