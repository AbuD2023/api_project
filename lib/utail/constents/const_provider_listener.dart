import 'package:api_project/controller/api_controller/user_provider_api_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConstProviderListener {
  // listener for provider api controller (UsersProviderApiController)
  UsersProviderApiController usersProviderApiControllerListener(
      {required BuildContext context}) {
    return Provider.of<UsersProviderApiController>(context, listen: false);
  }
}
