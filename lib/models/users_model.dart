class UsersModel {
  final String? name;
  final String? id;
  final String? email;

  UsersModel({
    this.name,
    this.id,
    this.email,
  });

  UsersModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        id = json['id'] as String?,
        email = json['email'] as String?;

  Map<String, dynamic> toJson() => {'name': name, 'id': id, 'email': email};
}
