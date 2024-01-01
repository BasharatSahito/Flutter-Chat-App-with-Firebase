import 'package:chat_app/main.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/services/apis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: mq.height * 0.05),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mq.height * 0.3),
                  border: Border.all(
                    color: Colors.black87,
                    width: mq.width * 0.001,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.3),
                  child: Image.network(
                    APIs.auth.currentUser?.photoURL.toString() ?? "",
                    fit: BoxFit.fill,
                    height: mq.height * .2,
                  ),
                ),
              ),
              SizedBox(
                height: mq.height * 0.02,
              ),
              StreamBuilder(
                stream: APIs.getSelfInfo(),
                builder: (context, snapshot) {
                  var data = snapshot.data?.data();
                  String name = data?["name"] ?? "Default Name";
                  String email = data?["email"] ?? "Default Email";
                  return Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: mq.width * 0.07,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: mq.height * 0.01,
                      ),
                      Text(
                        email,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: mq.width * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: mq.height * 0.3,
                      ),
                    ],
                  );
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      fixedSize: Size(
                        mq.width * 0.5,
                        mq.height * 0.07,
                      )),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn()
                        .signOut()
                        .then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            )));
                  },
                  child: Text(
                    "LOGOUT",
                    style: TextStyle(
                        fontSize: mq.width * 0.05, color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
