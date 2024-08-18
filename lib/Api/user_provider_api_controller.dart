import 'dart:convert';
import 'dart:developer';

import 'package:api_project/models/user_model.dart';
import 'package:api_project/utail/constents/api_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersProviderApiController with ChangeNotifier {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  List<UserModels> _users = [];
  List<UserModels> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Get Users From Api for List <Models> function
  Future<void> fetchUsers() async {
    // Start Loading Data From Api (Users) ...
    _isLoading = true;
    // notifyListeners(); // لتحديث الواجهة بعد تحميل المستخدمين ...
    notifyListeners();

    try {
      // Get Users From Api ...
      final response = await http.get(Uri.parse('${ApiUrl().baseUrl}users'));

      log('${response.statusCode}');
      // Check Response From Api ...
      if (response.statusCode == 200) {
        // Get Data From Api and json decode it ...
        List<dynamic> data = json.decode(response.body);
        // Add Data To List <Models> and notify Listeners
        _users = data.map((json) => UserModels.fromJson(json)).toList();
        log('نجح في تحميل المستخدمين 😊');
      } else {
        log('فشل في تحميل المستخدمين 😡');
      }
    } catch (e) {
      rethrow;
    } finally {
      // End Loading Data From Api (Users) ...
      _isLoading = false;
      // notifyListeners(); // لتحديث الواجهة بعد تحميل المستخدمين ...
      notifyListeners();
      // log('finally'); // للتحقق من نجاح عند تحميل المستخدمين ...
      log('notifyListeners');
    }
  }

  // Add User To Api function
  Future<void> addUser() async {
    try {
      // Create User Model from UI (Controllers)
      UserModels user = UserModels(
        id: 0,
        name: name.text.toString(),
        password: password.text.toString(),
      );

      // Add to api and get response from api (201 = created)
      final response = await http.post(
        Uri.parse('${ApiUrl().baseUrl}users'),
        // json encode user to api (201 = created)
        headers: {'Content-Type': 'application/json'},
        // add user to api
        body: jsonEncode(user.toJson()),
      );

      log('${response.statusCode}');
      // Check response from api (201 = created)
      if (response.statusCode == 201) {
        // Add to List <Models>
        _users.add(user);
        // Add to UI and notify Listeners to update UI with new data from api (Refresh UI)
        notifyListeners();
        // تنظيف الحقول بعد الإضافة
        clearControllers();
        // Success while adding user to api (201 = created)  طباعة اثناء ال DEBUG للتحقق من نجاح الإضافة ...
        log('تم إضافة المستخدم بنجاح 😊');
      } else {
        // Error while adding user to api
        log('فشل في إضافة المستخدم 😡');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser({required int id}) async {
    try {
      // update User Model from UI (Controllers)
      UserModels updatedUser = UserModels(
        id: id,
        name: name.text.toString(),
        password: password.text.toString(),
      );

      // update user to api and get response from api (204 = update)
      final response = await http.put(
        Uri.parse('${ApiUrl().baseUrl}users/$id'),
        // json encode user to api (200 = created)
        headers: {'Content-Type': 'application/json'},
        // update user to api
        body: jsonEncode(updatedUser.toJson()),
      );

      //
      log('${response.statusCode}');
      if (response.statusCode == 204) {
        // تحديث بيانات المستخدم في القائمة المحلية
        int index = _users.indexWhere((user) => user.id == id);
        if (index != -1) {
          _users[index] = updatedUser;
          // update to List <Models>
          notifyListeners();
        }

        clearControllers();
        // Success while updateing user to api (204 = update)  طباعة اثناء ال DEBUG للتحقق من نجاح التعديل ...
        log('تم تعديل المستخدم بنجاح 😊');
      } else {
        // Error while adding user to api
        log('فشل في تعديل المستخدم 😡');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser({required int id}) async {
    try {
      // delete user to api and get response from api (204 = created)
      final response = await http.delete(
        Uri.parse('${ApiUrl().baseUrl}users/$id'),
        // json encode user to api (204 = Delete)
        headers: {'Content-Type': 'application/json'},
      );

      //
      log('${response.statusCode}');
      if (response.statusCode == 204) {
        // حذف بيانات المستخدم في القائمة المحلية
        int index = _users.indexWhere((user) => user.id == id);
        if (index != -1) {
          _users.removeAt(index);
          notifyListeners();
        }

        clearControllers();
        // Success while Delete user to api (204 = delete)  طباعة اثناء ال DEBUG للتحقق من نجاح الحذف ...
        log('تم الحذف المستخدم بنجاح 😊');
      } else {
        // Error while delete user to api
        log('فشل في حذف المستخدم 😡');
      }
    } catch (e) {
      rethrow;
    }
  }

  // clear the Text Editing Controller
  void clearControllers() {
    name.clear();
    password.clear();
  }
}
