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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Bouncing curve
    final Animation<double> curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 1.0, curve: Curves.easeOut),
    ).drive(CurveTween(curve: Curves.elasticOut));

    _animation = Tween<double>(begin: 0, end: 1.0).animate(curvedAnimation);

    // Start the animation
    _controller.forward();

    // Commented out future logic
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FirebaseAuth.instance.currentUser != null
                ? const ChatsList()
                : const LoginScreen(),
          ));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            "assets/logo.png",
            height: mq.height * .2,
          ),
        ),
      ),
    );
  }
}
