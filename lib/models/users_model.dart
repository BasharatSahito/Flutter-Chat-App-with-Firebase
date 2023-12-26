import 'package:chat_app/models/my_user_model.dart';

class UsersModel {
  final String? name;
  final String? id;
  final String? email;
  late List<MyUserModel>? myUsers;

  UsersModel({
    this.name,
    this.id,
    this.email,
    this.myUsers,
  });

  UsersModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        id = json['id'] as String?,
        email = json['email'] as String?,
        myUsers = (json['my_users'] as List<dynamic>?)
            ?.map((e) => MyUserModel.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'email': email,
        'my_users': myUsers?.map((e) => e.toJson()).toList(),
      };
}
