import 'package:chat_app/models/messages_model.dart';
import 'package:chat_app/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

//Checking IF the User Already Exist in the Firestore Database
  static Future<bool> userExist() async {
    try {
      DocumentSnapshot userSnapshot =
          await firestore.collection("users").doc(auth.currentUser!.uid).get();
      return userSnapshot.exists;
    } catch (e) {
      debugPrint("Error checking user existence: $e");
      return false;
    }
  }

//Creating a New User in the Firestore Database
  static Future<void> createNewUser() async {
    final newUser = UsersModel(
        id: auth.currentUser!.uid,
        email: auth.currentUser?.email,
        name: auth.currentUser!.displayName);

    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .set(newUser.toJson());
  }

//Getting all users to show in chat list
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("users")
        .where(FieldPath.documentId, isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

//useful for getting conversation id
  static String getConversationID(String recieverId) {
    if (auth.currentUser!.uid.hashCode <= recieverId.hashCode) {
      return '${auth.currentUser!.uid}_$recieverId';
    } else {
      return '${recieverId}_${auth.currentUser!.uid}';
    }
  }

  //Getting all users to show in chat list
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    UsersModel user,
  ) {
    return firestore
        .collection("messages/${getConversationID(user.id.toString())}/chats")
        .orderBy('timestamp',
            descending: true) // Order by timestamp in descending order
        .snapshots();
  }

  //Creating Messages and Also sending message
  static Future<void> sendMessage(UsersModel user, String msg) async {
    final messages = MessagesModel(
      msg: msg,
      sentfrom: auth.currentUser!.uid,
      sentto: user.id,
      timestamp: Timestamp.now(),
    );

    final ref = firestore.collection("messages");
    ref
        .doc(getConversationID(user.id.toString()))
        .collection('chats')
        .add(messages.toJson());
  }
}
