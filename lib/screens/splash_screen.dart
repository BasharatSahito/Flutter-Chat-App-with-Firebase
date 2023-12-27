import 'package:chat_app/main.dart';
import 'package:chat_app/screens/chats_list.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(milliseconds: 1500), () {
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => FirebaseAuth.instance.currentUser != null
    //             ? const ChatsList()
    //             : const LoginScreen(),
    //       ));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "SPLASH SCREEN",
          style: TextStyle(fontSize: mq.width * .1),
        ),
      ),
    );
  }
}
