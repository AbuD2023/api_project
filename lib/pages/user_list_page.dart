import 'package:api_project/controller/api_controller/user_provider_api_controller.dart';
import 'package:api_project/models/user_model.dart';
import 'package:api_project/pages/add_user_page.dart';
import 'package:api_project/utail/constents/const_provider_listener.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // استدعاء `fetchUsers` مرة واحدة عند بناء الشاشة
    // Provider.of<UsersProviderApiController>(context, listen: false).fetchUsers();

    // تأجيل استدعاء `fetchUsers` إلى ما بعد اكتمال عملية البناء
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UsersProviderApiController>(context, listen: false)
          .fetchUsers();

      ///WidgetsBinding.instance.addPostFrameCallback:
      /// هذه الطريقة تضمن استدعاء
      ///  fetchUsers()
      /// فقط بعد انتهاء بناء جميع
      ///  widgets،
      ///  مما يمنع حدوث الخطأ المرتبط بإعادة البناء أثناء البناء.
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
      ),
      body: Consumer<UsersProviderApiController>(
        builder: (context, usersApiController, child) {
          if (usersApiController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (usersApiController.users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: usersApiController.users.length,
            itemBuilder: (context, index) {
              UserModels user = usersApiController.users[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(user.name!),
                subtitle: Text(user.password!),
                onTap: () {
                  ConstProviderListener()
                      .usersProviderApiControllerListener(context: context)
                      .name
                      .text = user.name!;
                  ConstProviderListener()
                      .usersProviderApiControllerListener(context: context)
                      .password
                      .text = user.password!;
                  showDialog(
                    context: context,
                    builder: (context) => AddUserPage(
                      buttonWidget: const Text('Update'),
                      name: ConstProviderListener()
                          .usersProviderApiControllerListener(context: context)
                          .name,
                      password: ConstProviderListener()
                          .usersProviderApiControllerListener(context: context)
                          .password,
                      onSubmit: () async {
                        await ConstProviderListener()
                            .usersProviderApiControllerListener(
                                context: context)
                            .updateUser(id: user.id!)
                            .then((value) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            showCloseIcon: true,
                            content: Text(
                              'تم التعديل بنجاح',
                              textDirection: TextDirection.rtl,
                            ),
                          ));
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
                onLongPress: () async {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      showCloseIcon: true,
                      duration: Duration(milliseconds: 1200),
                      content: Row(
                        children: [
                          IconButton(
                              onPressed: () async =>
                                  await ConstProviderListener()
                                      .usersProviderApiControllerListener(
                                          context: context)
                                      .deleteUser(id: user.id!)
                                      .then((value) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      showCloseIcon: true,
                                      content: Text(
                                        'تم الحذف بنجاح',
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ));
                                  }),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          Text(
                              'هل انت متاكد من حذف هذا المستخدم؟ ${user.name}'),
                        ],
                      )));
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: ElevatedButton(
          onPressed: () => showDialog(
                context: context,
                builder: (context) => AddUserPage(
                  buttonWidget: const Text('Save'),
                  name: ConstProviderListener()
                      .usersProviderApiControllerListener(context: context)
                      .name,
                  password: ConstProviderListener()
                      .usersProviderApiControllerListener(context: context)
                      .password,
                  onSubmit: () async {
                    await ConstProviderListener()
                        .usersProviderApiControllerListener(context: context)
                        .addUser()
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        showCloseIcon: true,
                        content: Text(
                          'تمت اللإضافة بنجاح',
                          textDirection: TextDirection.rtl,
                        ),
                      ));
                    });

                    Navigator.of(context).pop();
                  },
                ),
              ),
          child: const Text('Add')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // يمكنك استخدام هذا الزر لجلب البيانات مرة أخرى إذا لزم الأمر
          await Provider.of<UsersProviderApiController>(context, listen: false)
              .fetchUsers();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
