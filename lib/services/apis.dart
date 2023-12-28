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

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    debugPrint('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != auth.currentUser!.uid) {
      //user exists

      debugPrint('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

//Creating a New User in the Firestore Database
  static Future<void> createNewUser() async {
    final newUser = UsersModel(
      id: auth.currentUser!.uid,
      email: auth.currentUser?.email,
      name: auth.currentUser!.displayName,
      photoUrl: auth.currentUser!.photoURL,
    );

    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .set(newUser.toJson());
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('my_users')
        .snapshots();
  }

//Getting all users to show in chat list
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> myUserIds) {
    return firestore
        .collection("users")
        .where(FieldPath.documentId,
            whereIn: myUserIds.isEmpty
                ? ['']
                : myUserIds) //because empty list throws an error)
        // .where(FieldPath.documentId, isNotEqualTo: auth.currentUser!.uid)
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

  //Getting all Messages to show in Coversation Screen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    UsersModel user,
  ) {
    return firestore
        .collection("messages/${getConversationID(user.id.toString())}/chats")
        .orderBy('timestamp',
            descending: true) // Order by timestamp in descending order
        .snapshots();
  }

  // for adding an user to my user when first message is sent
  static Future<void> sendFirstMessage(UsersModel user, String msg) async {
    final timestamp = Timestamp.now();

    // Update sender's my_users collection with the timestamp
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('my_users')
        .doc(user.id)
        .set({'timestamp': timestamp});

    // Update receiver's my_users collection with the timestamp
    await firestore
        .collection('users')
        .doc(user.id)
        .collection('my_users')
        .doc(auth.currentUser!.uid)
        .set({'timestamp': timestamp});

    // Send the message
    await sendMessage(user, msg, timestamp);
  }

// Creating Messages Database and also sending message
  static Future<void> sendMessage(
      UsersModel user, String msg, Timestamp timestamp) async {
    final messages = MessagesModel(
      msg: msg,
      sentfrom: auth.currentUser!.uid,
      sentto: user.id,
      timestamp: timestamp,
    );

    final ref = firestore.collection("messages");
    ref
        .doc(getConversationID(user.id.toString()))
        .collection('chats')
        .add(messages.toJson());

    // Update sender's my_users collection with the timestamp
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('my_users')
        .doc(user.id)
        .set({'timestamp': timestamp});

    // Update receiver's my_users collection with the timestamp
    await firestore
        .collection('users')
        .doc(user.id)
        .collection('my_users')
        .doc(auth.currentUser!.uid)
        .set({'timestamp': timestamp});
  }

  //Getting only last message to show in the chat tile
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
    UsersModel user,
  ) {
    return firestore
        .collection("messages/${getConversationID(user.id.toString())}/chats")
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }
}
