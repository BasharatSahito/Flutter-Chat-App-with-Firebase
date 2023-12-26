import 'package:chat_app/models/my_user_model.dart';
import 'package:chat_app/models/users_model.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/services/apis.dart';
import 'package:chat_app/widgets.dart/chat_tiles.dart';
import 'package:chat_app/widgets.dart/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  List<UsersModel> userDataList = [];

  // Timestamp? timestamp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat App",
        ),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut().then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    )));
              },
              child: const Text("LOGOUT"))
        ],
      ),
      body: StreamBuilder(
        stream: APIs.getMyUsersId(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());

            //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              var data = snapshot.data?.docs;

              // Convert the timestamp data to a list
              List<Timestamp?> timestamps = data
                      ?.map((e) => e.data()["timestamp"] as Timestamp?)
                      .toList() ??
                  [];
              print("Timestamps: $timestamps");
              return StreamBuilder(
                stream: APIs.getAllUsers(
                    snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    // if the data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    // return const Center(child: CircularProgressIndicator());
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
                      print("User Data List after assignment: $userDataList");

                      print(
                          "userDataList: ${userDataList.map((user) => user.myUsers?.first.toJson()).toList()}");

                      userDataList.sort((a, b) {
                        final timestampA = a.myUsers?.first.timestamp;
                        final timestampB = b.myUsers?.first.timestamp;

                        if (timestampA == null && timestampB == null) return 0;
                        if (timestampA == null) return 1;
                        if (timestampB == null) return -1;

                        // Sort in descending order based on seconds
                        return timestampB.seconds.compareTo(timestampA.seconds);
                      });

                      print("After Sorting: $userDataList");

                      print(
                          "After Sorting: ${userDataList.map((user) => user.myUsers?.first.timestamp).toList()}");

                      if (userDataList.isNotEmpty) {
                        return Column(
                          children: [
                            Text(
                                "Logged in as: ${APIs.auth.currentUser!.displayName}"),
                            Expanded(
                              child: ListView.builder(
                                itemCount: userDataList.length,
                                itemBuilder: (context, index) {
                                  return ChatTiles(user: userDataList[index]);
                                },
                              ),
                            ),
                          ],
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
      //floating button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
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
                    color: Colors.blue,
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
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
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
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

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
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
