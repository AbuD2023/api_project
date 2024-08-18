class UserModels {
  int? id;
  String? name;
  String? password;

  UserModels({this.id, this.name, this.password});

  UserModels.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    password = json['password'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id as int;
    data['name'] = name as String;
    data['password'] = password as String;
    return data;
  }
}
