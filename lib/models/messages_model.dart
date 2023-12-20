import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
  final String? msg;
  final String? sentto;
  final String? sentfrom;
  final Timestamp? timestamp;

  MessagesModel({
    this.msg,
    this.sentto,
    this.sentfrom,
    this.timestamp,
  });

  MessagesModel.fromJson(Map<String, dynamic> json)
      : msg = json['msg'] as String?,
        sentto = json['sentto'] as String?,
        sentfrom = json['sentfrom'] as String?,
        timestamp = json['timestamp'] as Timestamp?;

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'sentto': sentto,
        'sentfrom': sentfrom,
        'timestamp': timestamp
      };
}
