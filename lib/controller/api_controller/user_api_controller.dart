import 'dart:convert';

import 'package:api_project/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersApiController with ChangeNotifier {
  Future<List<UserModels>> get() async {
    try {
      final res =
          await http.get(Uri.parse(('https://www.wist.somee.com/api/users')));
      if (res.statusCode == 200) {
        List<dynamic> data = json.decode(res.body);
        List<UserModels> users =
            data.map((json) => UserModels.fromJson(json)).toList();
        return users;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> post(UserModels user) async {
    try {
      final res = await http.post(
        Uri.parse('https://www.wist.somee.com/api/users'),
        body: user.toJson(),
      );
      if (res.statusCode == 201) {
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
