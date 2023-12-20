import 'package:chat_app/models/users_model.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/services/apis.dart';
import 'package:chat_app/widgets.dart/chat_tiles.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat App",
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: APIs.getAllUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // if the data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              var data = snapshot.data?.docs;

              userDataList =
                  data?.map((e) => UsersModel.fromJson(e.data())).toList() ??
                      [];

              if (userDataList.isNotEmpty) {
                return Column(
                  children: [
                    Text("Logged in as: ${APIs.auth.currentUser!.displayName}"),
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
                return const Center(child: Text("NO CONNECTIONS FOUND"));
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "LOGOUT",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut().then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              )));
        },
      ),
    );
  }
}
