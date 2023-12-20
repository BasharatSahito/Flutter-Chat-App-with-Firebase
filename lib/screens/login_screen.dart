import 'package:chat_app/main.dart';
import 'package:chat_app/screens/chats_list.dart';
import 'package:chat_app/services/apis.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets.dart/dialogs.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  // final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _handleGoogleLoginBtn() {
    //for showing circular progress bar
    Dialogs.showProgressBar(context);
    Auth.signInWithGoogle(context).then((user) async {
      //for hiding circular progress bar
      Navigator.pop(context);
      print("\nUser INFO: ${user?.user}");
      if (user?.user != null) {
        //checking if user already exists in the firestore database
        if ((await APIs.userExist())) {
          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatsList(),
                ));
          }
        } else {
          //saving the of user in Firestore Database
          APIs.createNewUser().then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatsList(),
              )));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: mq.width * .5,
              color: Colors.black87,
            ),
            SizedBox(
              height: mq.height * 0.4,
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    fixedSize: Size(
                      mq.width * 0.8,
                      mq.height * 0.07,
                    )),
                onPressed: () {
                  _handleGoogleLoginBtn();
                },
                icon: Padding(
                  padding: EdgeInsets.only(right: mq.width * 0.02),
                  child: Icon(
                    Icons.login,
                    size: mq.width * 0.09,
                    color: Colors.white,
                  ),
                ),
                label: Text(
                  "LOGIN WITH GOOGLE",
                  style:
                      TextStyle(fontSize: mq.width * 0.05, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
