import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserModel {
  final Timestamp? timestamp;

  MyUserModel({
    this.timestamp,
  });

  factory MyUserModel.fromJson(Map<String, dynamic> json) {
    return MyUserModel(
      timestamp: json['timestamp'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
      };
}
