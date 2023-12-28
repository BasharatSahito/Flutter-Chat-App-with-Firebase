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
  List<Map<String, String>> userInfo = [
    // {
    //   "fieldName": "Profile Name",
    //   "fieldValue": APIs.auth.currentUser?.displayName.toString()
    // },
    {
      "fieldName": "Email",
      "fieldValue": APIs.auth.currentUser?.email.toString() ?? ""
    }
  ];

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
                    color: Colors
                        .black87, // You can change the color of the border here
                    width: mq.width *
                        0.001, // You can adjust the width of the border
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
              Text(
                APIs.auth.currentUser?.displayName.toString() ?? "",
                style: TextStyle(
                    fontSize: mq.width * 0.07, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: mq.height * 0.01,
              ),
              Text(
                APIs.auth.currentUser?.email.toString() ?? "",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: mq.width * 0.05,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: mq.height * 0.3,
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
              // Expanded(
              //   child: Padding(
              //       padding: EdgeInsets.symmetric(
              //         vertical: mq.height * 0.05,
              //         horizontal: mq.width * 0.07,
              //       ),
              //       child: ListView.builder(
              //         itemCount: userInfo.length,
              //         itemBuilder: (context, index) {
              //           return Row(
              //             children: [
              //               Expanded(
              //                 flex:
              //                     2, // This will take up 2 parts of the available space
              //                 child: Text(
              //                   userInfo[index]['fieldName'].toString(),
              //                   style: TextStyle(
              //                       fontSize: mq.width * 0.04,
              //                       fontWeight: FontWeight.bold),
              //                 ),
              //               ),
              //               Expanded(
              //                 flex:
              //                     3, // This will take up 3 parts of the available space
              //                 child: Text(
              //                   userInfo[index]["fieldValue"].toString(),
              //                   style: TextStyle(
              //                       fontSize: mq.width * 0.04,
              //                       fontWeight: FontWeight.bold),
              //                 ),
              //               )
              //             ],
              //           );
              //         },
              //       )),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
